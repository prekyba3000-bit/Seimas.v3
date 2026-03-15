mod hero;
mod forensics;

use crate::hero::HeroService;
use crate::forensics::ForensicService;
use axum::{
    extract::{Path, State},
    routing::get,
    Json, Router,
};
use seimas_core::Politician;
use sqlx::PgPool;
use std::net::SocketAddr;
use tower_http::cors::CorsLayer;
use tracing::info;
use uuid::Uuid;
use anyhow::Result;

use crate::hero::HeroProfile;
use crate::forensics::service::MpForensicReport;

#[derive(Clone)]
struct AppState {
    pool: PgPool,
    hero_service: std::sync::Arc<HeroService>,
    forensic_service: std::sync::Arc<ForensicService>,
}

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt::init();

    let database_url = std::env::var("DB_DSN").expect("DB_DSN must be set");
    let pool = PgPool::connect(&database_url).await?;

    let state = AppState { 
        pool: pool.clone(),
        hero_service: std::sync::Arc::new(HeroService::new(pool.clone())),
        forensic_service: std::sync::Arc::new(ForensicService::new(pool)),
    };

    let api_routes = Router::new()
        // Investigative / Journalism Endpoints
        .nest("/investigative", Router::new()
            .route("/mps/:id/report", get(get_forensic_report))
            .route("/mps", get(get_politicians))
        )
        // Gamified / Hero Endpoints
        .nest("/gamified", Router::new()
            .route("/heroes/:id", get(get_hero_profile))
            .route("/votes", get(get_votes))
        );

    let app = Router::new()
        .nest("/api/v1", api_routes)
        .layer(CorsLayer::permissive())
        .with_state(state);

    let addr = SocketAddr::from(([0, 0, 0, 0], 8000));
    info!("Seimas V3 API listening on {} (Dual-Interface Enabled)", addr);
    
    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}

// --- Handler Functions ---

async fn get_politicians(State(state): State<AppState>) -> Json<Vec<Politician>> {
    let politicians = sqlx::query_as::<_, Politician>("SELECT * FROM politicians ORDER BY display_name")
        .fetch_all(&state.pool)
        .await
        .unwrap_or_default();
    Json(politicians)
}

async fn get_hero_profile(
    State(state): State<AppState>, 
    Path(id): Path<Uuid>
) -> Json<Option<HeroProfile>> {
    match state.hero_service.get_profile(id).await {
        Ok(profile) => Json(Some(profile)),
        Err(e) => {
            tracing::error!("Failed to fetch hero profile: {}", e);
            Json(None)
        }
    }
}

async fn get_forensic_report(
    State(state): State<AppState>, 
    Path(id): Path<Uuid>
) -> Json<Option<MpForensicReport>> {
    match state.forensic_service.get_mp_report(id).await {
        Ok(report) => Json(Some(report)),
        Err(e) => {
            tracing::error!("Failed to fetch forensic report: {}", e);
            Json(None)
        }
    }
}

async fn get_votes(State(state): State<AppState>) -> Json<Vec<seimas_core::Vote>> {
    let votes = sqlx::query_as::<_, seimas_core::Vote>("SELECT * FROM votes ORDER BY sitting_date DESC LIMIT 100")
        .fetch_all(&state.pool)
        .await
        .unwrap_or_default();
    Json(votes)
}
