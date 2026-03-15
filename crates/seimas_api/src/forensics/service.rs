use seimas_core::{Politician, AmendmentProfile};
use sqlx::{PgPool, FromRow};
use uuid::Uuid;
use serde::Serialize;
use anyhow::Result;

#[derive(Debug, Serialize, FromRow)]
pub struct BenfordStats {
    pub mp_id: Uuid,
    pub sample_size: i32,
    pub chi_squared: f32,
    pub p_value: f32,
    pub mad: f32,
    pub conformity_label: String,
}

#[derive(Debug, Serialize)]
pub struct MpForensicReport {
    pub mp_id: Uuid,
    pub name: String,
    pub benford: Option<BenfordStats>,
    pub amendment_profiles: Vec<AmendmentProfile>,
    pub risk_score: f32,
}

pub struct ForensicService {
    pool: PgPool,
}

impl ForensicService {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn get_mp_report(&self, mp_id: Uuid) -> Result<MpForensicReport> {
        let mp = sqlx::query_as::<_, Politician>("SELECT * FROM politicians WHERE id = $1")
            .bind(mp_id)
            .fetch_one(&self.pool)
            .await?;

        let benford = sqlx::query_as::<_, BenfordStats>(
            "SELECT mp_id, sample_size, chi_squared, p_value, mad, conformity_label FROM benford_analyses WHERE mp_id = $1"
        )
        .bind(mp_id)
        .fetch_optional(&self.pool)
        .await?;

        let profiles = sqlx::query_as::<_, AmendmentProfile>(
            "SELECT * FROM amendment_profiles WHERE amendment_id IN (SELECT amendment_id FROM amendments WHERE proposer_mp_id = $1) ORDER BY computed_at DESC"
        )
        .bind(mp_id)
        .fetch_all(&self.pool)
        .await?;

        // Risk score calculation for journalists
        let mut risk_score = 0.0;
        if let Some(ref b) = benford {
            if b.mad > 0.015 { risk_score += 40.0; }
            else if b.mad > 0.012 { risk_score += 20.0; }
        }
        
        let anomalies = profiles.iter().filter(|p| p.speed_anomaly_zscore.unwrap_or(0.0) > 2.0).count();
        risk_score += (anomalies as f32 * 10.0).min(50.0);

        Ok(MpForensicReport {
            mp_id: mp.id,
            name: mp.display_name,
            benford,
            amendment_profiles: profiles,
            risk_score: risk_score.min(100.0),
        })
    }
}
