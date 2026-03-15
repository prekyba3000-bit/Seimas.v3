mod graph;

use anyhow::{Context, Result};
use seimas_core::{Politician, Amendment};
use sqlx::{PgPool, Row};
use std::collections::HashMap;
use tracing::info;
use statrs::distribution::{ChiSquared, ContinuousCDF};
use uuid::Uuid;

fn mean(data: &[f64]) -> Option<f64> {
    if data.is_empty() { return None; }
    Some(data.iter().sum::<f64>() / data.len() as f64)
}

fn std_dev(data: &[f64]) -> Option<f64> {
    let m = mean(data)?;
    let variance = data.iter().map(|value| {
        let diff = m - (*value);
        diff * diff
    }).sum::<f64>() / data.len() as f64;
    Some(variance.sqrt())
}

fn median(data: &mut [f64]) -> Option<f64> {
    if data.is_empty() { return None; }
    data.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let mid = data.len() / 2;
    if data.len() % 2 == 0 {
        Some((data[mid - 1] + data[mid]) / 2.0)
    } else {
        Some(data[mid])
    }
}

const BENFORD_EXPECTED: [f64; 9] = [
    0.30103, 0.17609, 0.12494, 0.09691, 0.07918, 0.06695, 0.05799, 0.05115, 0.04576,
];

const MIN_SAMPLE_SIZE: usize = 15;

fn leading_digit(value: f64) -> Option<usize> {
    if value == 0.0 { return None; }
    let s = value.abs().to_string().replace(".", "").trim_start_matches('0').to_string();
    s.chars().next()?.to_digit(10).map(|d| d as usize).filter(|&d| d > 0)
}

fn compute_mad(observed_pct: &[f64; 9]) -> f64 {
    observed_pct.iter().zip(BENFORD_EXPECTED.iter())
        .map(|(o, e)| (o - e).abs())
        .sum::<f64>() / 9.0
}

pub async fn run_benford_analysis(pool: &PgPool) -> Result<()> {
    info!("Starting Benford's Law analysis...");
    
    // Fetch all politicians
    let mps = sqlx::query_as::<_, Politician>("SELECT * FROM politicians")
        .fetch_all(pool)
        .await?;

    for mp in mps {
        // Fetch wealth declarations for this MP
        let declarations = sqlx::query(
            "SELECT real_estate_value::FLOAT8 as re_val, vehicles_value::FLOAT8 as v_val, financial_assets::FLOAT8 as f_val, declared_income::FLOAT8 as d_val FROM assets WHERE politician_id = $1"
        )
        .bind(mp.id)
        .fetch_all(pool)
        .await?;

        let mut values: Vec<f64> = Vec::new();
        for d in declarations {
            let re_val: Option<f64> = d.get("re_val");
            let f_val: Option<f64> = d.get("f_val");
            let d_val: Option<f64> = d.get("d_val");
            if let Some(v) = re_val { values.push(v); }
            if let Some(v) = f_val { values.push(v); }
            if let Some(v) = d_val { values.push(v); }
        }

        let digits: Vec<usize> = values.into_iter()
            .filter_map(leading_digit)
            .collect();

        if digits.len() < MIN_SAMPLE_SIZE { continue; }

        let mut counts = [0usize; 9];
        for d in digits.iter() { counts[d - 1] += 1; }

        let total = digits.len() as f64;
        let mut observed_pct = [0.0; 9];
        let mut chi_squared = 0.0;

        for i in 0..9 {
            let o = counts[i] as f64;
            let expected = BENFORD_EXPECTED[i] * total;
            observed_pct[i] = o / total;
            chi_squared += (o - expected).powi(2) / expected;
        }

        let mad = compute_mad(&observed_pct);
        
        // p-value calculation using statrs
        let p_value = 1.0 - ChiSquared::new(8.0).unwrap().cdf(chi_squared);

        let label = if mad <= 0.006 { "conforming" }
                    else if mad <= 0.012 { "acceptable" }
                    else if mad <= 0.015 { "marginal" }
                    else { "non-conforming" };

        info!("MP {}: MAD={:.5}, P-Value={:.5}, Label={}", mp.display_name, mad, p_value, label);

        // Upsert analysis result
        sqlx::query(
            "INSERT INTO benford_analyses (mp_id, sample_size, chi_squared, p_value, mad, conformity_label, computed_at)
             VALUES ($1, $2, $3, $4, $5, $6, NOW())
             ON CONFLICT (mp_id) DO UPDATE SET
                sample_size = EXCLUDED.sample_size,
                chi_squared = EXCLUDED.chi_squared,
                p_value = EXCLUDED.p_value,
                mad = EXCLUDED.mad,
                conformity_label = EXCLUDED.conformity_label,
                computed_at = NOW()"
        )
        .bind(&mp.id)
        .bind(digits.len() as i32)
        .bind(chi_squared as f32)
        .bind(p_value as f32)
        .bind(mad as f32)
        .bind(label)
        .execute(pool)
        .await?;
    }

    Ok(())
}



lazy_static::lazy_static! {
    static ref CITATION_PATTERN: regex::Regex = regex::Regex::new(r"(?i)\b(?:straipsn|įstatym|direktyv|nutarim|Nr\.\s*\w+)").unwrap();
}

fn compute_complexity(word_count: i32, citation_count: i32) -> f32 {
    word_count as f32 + (citation_count as f32 * 15.0)
}

pub async fn run_chrono_analysis(pool: &PgPool) -> Result<()> {
    info!("Starting Chrono-forensics analysis...");

    let amendments = sqlx::query_as::<_, Amendment>( 
        "SELECT * FROM amendments WHERE amendment_text IS NOT NULL AND proposed_at IS NOT NULL"
    )
    .fetch_all(pool)
    .await?;

    if amendments.is_empty() {
        info!("No amendments to analyze.");
        return Ok(());
    }

    let mut mp_amendments: HashMap<Uuid, Vec<Amendment>> = HashMap::new();
    for a in amendments {
        if let Some(mp_id) = a.proposer_mp_id {
            mp_amendments.entry(mp_id).or_default().push(a);
        }
    }

    for (_mp_id, mp_amends) in mp_amendments {
        let windows: Vec<f64> = mp_amends.iter()
            .filter_map(|a| a.lead_time_minutes.map(|w| w as f64))
            .collect();

        let mut windows_mut = windows.clone();
        let med = median(&mut windows_mut).unwrap_or(0.0);
        let std = std_dev(&windows).unwrap_or(1.0);
        let std = if std < 1.0 { 1.0 } else { std };

        for a in mp_amends {
            let text = a.amendment_text.as_deref().unwrap_or("");
            let word_count = text.split_whitespace().count() as i32;
            let citation_count = CITATION_PATTERN.find_iter(text).count() as i32;
            let complexity = compute_complexity(word_count, citation_count);
            let window = a.lead_time_minutes;

            let zscore = window.map(|w| (w as f64 - med) / std);

            sqlx::query(
                "INSERT INTO amendment_profiles (amendment_id, word_count, legal_citation_count, complexity_score, drafting_window_minutes, speed_anomaly_zscore, computed_at)
                 VALUES ($1, $2, $3, $4, $5, $6, NOW())
                 ON CONFLICT (amendment_id) DO UPDATE SET
                    word_count = EXCLUDED.word_count,
                    legal_citation_count = EXCLUDED.legal_citation_count,
                    complexity_score = EXCLUDED.complexity_score,
                    drafting_window_minutes = EXCLUDED.drafting_window_minutes,
                    speed_anomaly_zscore = EXCLUDED.speed_anomaly_zscore,
                    computed_at = NOW()"
            )
            .bind(&a.amendment_id)
            .bind(word_count)
            .bind(citation_count)
            .bind(complexity)
            .bind(window)
            .bind(zscore.map(|z| z as f32))
            .execute(pool)
            .await?;
        }
    }

    info!("Chrono-forensics: Porting DBSCAN clustering would require ndarray and a clustering crate like linfa.");
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt::init();

    let database_url = std::env::var("DB_DSN").context("DB_DSN must be set")?;
    let pool = PgPool::connect(&database_url).await?;

    run_benford_analysis(&pool).await?;
    run_chrono_analysis(&pool).await?;
    graph::run_loyalty_analysis(&pool).await?;
    graph::run_phantom_analysis(&pool).await?;

    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_leading_digit() {
        assert_eq!(leading_digit(123.45), Some(1));
        assert_eq!(leading_digit(0.0056), Some(5));
        assert_eq!(leading_digit(-9.8), Some(9));
        assert_eq!(leading_digit(0.0), None);
    }

    #[test]
    fn test_compute_complexity() {
        // word_count + (citation_count * 15.0)
        assert_eq!(compute_complexity(10, 2), 40.0);
        assert_eq!(compute_complexity(100, 0), 100.0);
    }

    #[test]
    fn test_mad() {
        let observed = [0.1; 9]; // uniform 10%
        let mad = compute_mad(&observed);
        assert!(mad > 0.0);
    }

    #[test]
    fn test_mean_std_dev() {
        let data = vec![1.0, 2.0, 3.0, 4.0, 5.0];
        assert_eq!(mean(&data), Some(3.0));
        assert!((std_dev(&data).unwrap() - 1.414).abs() < 0.001);
    }
}
