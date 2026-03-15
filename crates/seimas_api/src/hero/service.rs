use seimas_core::{Politician, AmendmentProfile};
use sqlx::{PgPool, FromRow};
use uuid::Uuid;
use std::collections::HashMap;
use serde::Serialize;
use anyhow::Result;

#[derive(Debug, Serialize, FromRow)]
pub struct BenfordAnalysis {
    pub mp_id: Uuid,
    pub mad: f32,
    pub conformity_label: String,
}

#[derive(Debug, Serialize)]
pub struct HeroProfile {
    pub mp_id: Uuid,
    pub level: i32,
    pub xp: i32,
    pub alignment: String,
    pub attributes: HashMap<String, i32>,
}

pub struct HeroService {
    pool: PgPool,
}

impl HeroService {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn get_profile(&self, mp_id: Uuid) -> Result<HeroProfile> {
        // 1. Fetch Benford Analysis (Conformity)
        let benford = sqlx::query_as::<_, BenfordAnalysis>(
            "SELECT mp_id, mad, conformity_label FROM benford_analyses WHERE mp_id = $1"
        )
        .bind(mp_id)
        .fetch_optional(&self.pool)
        .await?;

        // 2. Fetch Amendment Profiles (Complexity, Speed)
        let profiles = sqlx::query_as::<_, AmendmentProfile>(
            "SELECT * FROM amendment_profiles WHERE amendment_id IN (SELECT amendment_id FROM amendments WHERE proposer_mp_id = $1)"
        )
        .bind(mp_id)
        .fetch_all(&self.pool)
        .await?;

        // 3. Fetch MP Basic Info (Bills count)
        let mp = sqlx::query_as::<_, Politician>("SELECT * FROM politicians WHERE id = $1")
            .bind(mp_id)
            .fetch_one(&self.pool)
            .await?;

        // --- Attribute Logic ---
        
        // Intelligence: f(legal citations, -mad)
        let avg_citations = if profiles.is_empty() { 0.0 } else { 
            profiles.iter().map(|p| p.legal_citation_count.unwrap_or(0) as f32).sum::<f32>() / profiles.len() as f32 
        };
        let mad_bonus = benford.as_ref().map(|b| (0.015 - b.mad).max(0.0) * 1000.0).unwrap_or(0.0);
        let intelligence = (10.0 + avg_citations * 2.0 + mad_bonus).min(20.0) as i32;

        // Strength: f(complexity, bills count)
        let avg_complexity = if profiles.is_empty() { 0.0 } else { 
            profiles.iter().map(|p| p.complexity_score.unwrap_or(0.0)).sum::<f32>() / profiles.len() as f32 
        };
        let bills_count = mp.bills_authored_count.unwrap_or(0);
        let strength = (10.0 + (avg_complexity / 50.0) + (bills_count as f32 / 5.0)).min(20.0) as i32;

        // Speed: f(-drafting window)
        let avg_window = if profiles.is_empty() { 1440.0 } else {
            profiles.iter().filter_map(|p| p.drafting_window_minutes.map(|w| w as f32)).sum::<f32>() / profiles.len() as f32
        };
        // Normalized speed: 10 base, +X if window < 24h (1440m)
        let speed = (10.0 + (1440.0 / avg_window.max(1.0)).min(10.0)) as i32;

        // Alignment logic
        let mut alignment = match benford.as_ref().map(|b| b.conformity_label.as_str()) {
            Some("conforming") => "Lawful".to_string(),
            Some("non-conforming") => "Chaotic".to_string(),
            _ => "Neutral".to_string(),
        };
        alignment.push_str(" Good"); // Static for now, could be based on other metrics later

        let mut attributes = HashMap::new();
        attributes.insert("Strength".to_string(), strength);
        attributes.insert("Intelligence".to_string(), intelligence);
        attributes.insert("Speed".to_string(), speed);

        // XP/Level calculation (very rudimentary)
        let xp = (bills_count * 100) + (profiles.len() as i32 * 50);
        let level = (xp / 500).max(1);

        Ok(HeroProfile {
            mp_id: mp.id,
            level,
            xp,
            alignment,
            attributes,
        })
    }
}
