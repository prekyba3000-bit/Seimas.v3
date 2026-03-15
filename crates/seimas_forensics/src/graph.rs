use anyhow::{Context, Result};
use chrono::NaiveDate;
use petgraph::graph::{NodeIndex, UnGraph};
use seimas_core::{Politician, MpVote, Vote};
use sqlx::PgPool;
use std::collections::HashMap;
use tracing::{info, warn};
use uuid::Uuid;

// --- Loyalty Engine ---

pub async fn run_loyalty_analysis(pool: &PgPool) -> Result<()> {
    info!("Starting Loyalty Graph analysis...");

    // Fetch substantial votes (e.g., from the last 6 months)
    let votes = sqlx::query_as::<_, Vote>("SELECT * FROM votes ORDER BY sitting_date DESC LIMIT 100")
        .fetch_all(pool)
        .await?;

    let mut graph = UnGraph::<Uuid, f32>::default();
    let mut nodes = HashMap::new();

    for v in votes {
        let mp_votes = sqlx::query_as::<_, MpVote>("SELECT * FROM mp_votes WHERE vote_id = $1")
            .bind(v.seimas_vote_id)
            .fetch_all(pool)
            .await?;

        // Compare every pair of MPs in this vote
        for i in 0..mp_votes.len() {
            for j in (i + 1)..mp_votes.len() {
                let v1 = &mp_votes[i];
                let v2 = &mp_votes[j];

                    let n1 = nodes.get(&v1.politician_id).cloned().unwrap_or_else(|| {
                        let idx = graph.add_node(v1.politician_id);
                        nodes.insert(v1.politician_id, idx);
                        idx
                    });
                    let n2 = nodes.get(&v2.politician_id).cloned().unwrap_or_else(|| {
                        let idx = graph.add_node(v2.politician_id);
                        nodes.insert(v2.politician_id, idx);
                        idx
                    });

                    if let Some(edge) = graph.find_edge(n1, n2) {
                        graph[edge] += 1.0;
                    } else {
                        graph.add_edge(n1, n2, 1.0);
                    }
            }
        }
    }

    info!("Loyalty Graph constructed with {} nodes and {} edges.", graph.node_count(), graph.edge_count());
    
    // In a real scenario, we'd persist clustering results or centralities back to the DB.
    Ok(())
}

// --- Phantom Network Engine ---

#[derive(serde::Deserialize, sqlx::FromRow)]
struct InterestLink {
    politician_id: Uuid,
    organization_name: String,
}

pub async fn run_phantom_analysis(pool: &PgPool) -> Result<()> {
    info!("Starting Phantom Network analysis...");

    let interests = sqlx::query_as::<_, InterestLink>( 
        "SELECT politician_id, organization_name FROM interests WHERE organization_name IS NOT NULL"
    )
    .fetch_all(pool)
    .await?;

    let mut graph = UnGraph::<String, ()>::default();
    let mut nodes = HashMap::new();

    for link in interests {
        let p_node = *nodes.entry(link.politician_id.to_string()).or_insert_with(|| graph.add_node(link.politician_id.to_string()));
        let o_node = *nodes.entry(link.organization_name.clone()).or_insert_with(|| graph.add_node(link.organization_name));
        
        graph.update_edge(p_node, o_node, ());
    }

    info!("Phantom Network: Found {} overlapping interest hubs.", graph.node_count());
    Ok(())
}

// --- main.rs Integration ---

// (I will update the main.rs to call these)
