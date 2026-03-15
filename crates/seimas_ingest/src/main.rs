use anyhow::{Context, Result};
use chrono::NaiveDate;
use quick_xml::de::from_str;
use reqwest::Client;
use serde::Deserialize;
use sqlx::{PgPool, Row};
use std::collections::HashMap;
use tracing::{info, warn};
use unidecode::unidecode;
use uuid::Uuid;

const BASE_URL: &str = "https://apps.lrs.lt/sip/p2b";
const SEIMAS_API_URL: &str = "https://apps.lrs.lt/sip/p2b.ad_seimo_nariai";
const PHOTO_BASE: &str = "https://www.lrs.lt/SIPIS/sn_foto/2024";
const TERM_ID: &str = "10"; // 2024-2028 Term

// --- XML Structures ---

#[derive(Debug, Deserialize)]
struct SeimoNariaiRoot {
    #[serde(rename = "SeimoNarys", default)]
    nariai: Vec<SeimoNarys>,
}

#[derive(Debug, Deserialize)]
struct SeimoNarys {
    #[serde(rename = "@asmens_id")]
    asmens_id: Option<i32>,
    #[serde(rename = "@vardas")]
    vardas: Option<String>,
    #[serde(rename = "@pavardė")]
    pavarde: Option<String>,
    #[serde(rename = "@data_iki")]
    data_iki: Option<String>,
    #[serde(rename = "@iškėlusi_partija")]
    iskelusi_partija: Option<String>,
}

#[derive(Debug, Deserialize)]
struct SessionsRoot {
    #[serde(rename = "SeimoSesija", default)]
    sesijos: Vec<SeimoSesija>,
}

#[derive(Debug, Deserialize)]
struct SeimoSesija {
    #[serde(rename = "@sesijos_id")]
    sesijos_id: Option<String>,
}

#[derive(Debug, Deserialize)]
struct SittingsRoot {
    #[serde(rename = "SeimoPosėdis", default)]
    posedziai: Vec<SeimoPosedis>,
}

#[derive(Debug, Deserialize)]
struct SeimoPosedis {
    #[serde(rename = "@posėdžio_id")]
    posedzio_id: Option<String>,
}

#[derive(Debug, Deserialize)]
struct AgendaRoot {
    #[serde(rename = "posedis")]
    posedis: Option<AgendaPosedis>,
    #[serde(rename = "darbotvarkes-klausimas", default)]
    klausimai: Vec<AgendaKlausimas>,
}

#[derive(Debug, Deserialize)]
struct AgendaPosedis {
    #[serde(rename = "data")]
    data: Option<String>,
}

#[derive(Debug, Deserialize)]
struct AgendaKlausimas {
    #[serde(rename = "pavadinimas")]
    pavadinimas: Option<String>,
    #[serde(rename = "@registracijos_nr")]
    registracijos_nr: Option<String>,
    #[serde(rename = "stadija")]
    stadija: Option<String>,
    #[serde(rename = "balsavimas", default)]
    balsavimai: Vec<Balsavimas>,
}

#[derive(Debug, Deserialize)]
struct Balsavimas {
    #[serde(rename = "@bals_id")]
    bals_id: Option<String>,
    #[serde(rename = "@balsavimo_id")]
    balsavimo_id: Option<String>,
}

#[derive(Debug, Deserialize)]
struct ResultsRoot {
    #[serde(rename = "BalsavimoRezultataiAntraštė")]
    antraste: Option<ResultsAntraste>,
    #[serde(rename = "IndividualusBalsavimoRezultatas", default)]
    individualus: Vec<IndividualResult>,
    #[serde(rename = "BalsavimoRezultatai", default)]
    rezultatai: Vec<IndividualResult>,
}

#[derive(Debug, Deserialize)]
struct ResultsAntraste {
    #[serde(rename = "@klausimo_pavadinimas")]
    klausimo_pavadinimas: Option<String>,
    #[serde(rename = "@balsavimo_tipas")]
    balsavimo_tipas: Option<String>,
}

#[derive(Debug, Deserialize)]
struct IndividualResult {
    #[serde(rename = "@asmens_id")]
    asmens_id: Option<i32>,
    #[serde(rename = "@sn_id")]
    sn_id: Option<i32>,
    #[serde(rename = "@kaip_balsavo")]
    kaip_balsavo: Option<String>,
    #[serde(rename = "@balsavimo_rezultatas")]
    balsavimo_rezultatas: Option<String>,
}

// --- Logic ---

fn normalize_name(name: &str) -> String {
    unidecode(name).to_lowercase().trim().split_whitespace().collect::<Vec<_>>().join(" ")
}

fn build_photo_url(first_name: &str, last_name: &str) -> String {
    let slug = unidecode(&format!("{} {}", first_name, last_name))
        .to_lowercase()
        .chars()
        .map(|c| if c.is_alphanumeric() { c } else { '_' })
        .collect::<String>()
        .trim_matches('_')
        .to_string();
    format!("{}/{}.jpg", PHOTO_BASE, slug)
}

pub async fn sync_mps(pool: &PgPool, client: &Client) -> Result<()> {
    info!("Fetching MPs from Seimas API...");
    let response = client.get(SEIMAS_API_URL).send().await?.text().await?;
    let root: SeimoNariaiRoot = from_str(&response).context("Failed to parse SeimoNariai XML")?;

    info!("Found {} MP records.", root.nariai.len());

    for narys in root.nariai {
        let mp_id = match narys.asmens_id {
            Some(id) => id,
            None => continue,
        };

        let first_name = narys.vardas.as_deref().unwrap_or("");
        let last_name = narys.pavarde.as_deref().unwrap_or("");
        let full_name = format!("{} {}", first_name, last_name);
        let normalized = normalize_name(&full_name);
        let party = narys.iskelusi_partija;
        
        let term_end = narys.data_iki.as_ref().and_then(|d| NaiveDate::parse_from_str(d, "%Y-%m-%d").ok());
        let is_active = term_end.is_none();
        let photo_url = build_photo_url(first_name, last_name);

        // Simple upsert for now
        sqlx::query(
            r#"
            INSERT INTO politicians (
                full_name_normalized, display_name, seimas_mp_id, current_party, is_active, term_end_date, photo_url
            ) VALUES ($1, $2, $3, $4, $5, $6, $7)
            ON CONFLICT (seimas_mp_id) DO UPDATE SET
                current_party = COALESCE(EXCLUDED.current_party, politicians.current_party),
                is_active = EXCLUDED.is_active,
                term_end_date = EXCLUDED.term_end_date,
                photo_url = EXCLUDED.photo_url
            "#
        )
        .bind(&normalized)
        .bind(&full_name)
        .bind(mp_id)
        .bind(&party)
        .bind(is_active)
        .bind(term_end)
        .bind(&photo_url)
        .execute(pool)
        .await?;
    }

    info!("Politicians sync complete.");
    Ok(())
}

pub async fn sync_votes(pool: &PgPool, client: &Client) -> Result<()> {
    info!("Starting voting ingestion for Term {}...", TERM_ID);
    
    let url = format!("{}.ad_seimo_sesijos?kadencijos_id={}", BASE_URL, TERM_ID);
    let s_xml = client.get(&url).send().await?.text().await?;
    let s_root: SessionsRoot = from_str(&s_xml).context("Failed to parse Sessions XML")?;
    let sessions: Vec<String> = s_root.sesijos.into_iter().filter_map(|s| s.sesijos_id).collect();
    
    info!("Found sessions: {:?}", sessions);

    let mp_map: HashMap<i32, Uuid> = sqlx::query("SELECT seimas_mp_id, id FROM politicians WHERE seimas_mp_id IS NOT NULL")
        .fetch_all(pool)
        .await?
        .into_iter()
        .filter_map(|r| {
            let sid: Option<i32> = r.get("seimas_mp_id");
            let id: Uuid = r.get("id");
            sid.map(|s| (s, id))
        })
        .collect();

    for sess_id in sessions {
        info!("Processing session {}...", sess_id);
        let s_url = format!("{}.ad_seimo_posedziai?sesijos_id={}", BASE_URL, sess_id);
        let s_xml = client.get(&s_url).send().await?.text().await?;
        let s_root: SittingsRoot = from_str(&s_xml).context("Failed to parse Sittings XML")?;
        
        let sittings: Vec<String> = s_root.posedziai.into_iter().filter_map(|p| p.posedzio_id).collect();
        info!("  Found {} sittings.", sittings.len());

        for sit_id in sittings {
            if let Err(e) = process_sitting(pool, client, &sit_id, &mp_map).await {
                warn!("    Failed to process sitting {}: {}", sit_id, e);
            }
        }
    }

    Ok(())
}

async fn process_sitting(pool: &PgPool, client: &Client, sit_id: &str, mp_map: &HashMap<i32, Uuid>) -> Result<()> {
    let url = format!("{}.ad_seimo_posedzio_eiga_full?posedzio_id={}", BASE_URL, sit_id);
    let xml = client.get(&url).send().await?.text().await?;
    let agenda: AgendaRoot = from_str(&xml).context("Failed to parse Agenda XML")?;

    let sit_date = agenda.posedis.and_then(|p| p.data).and_then(|d| NaiveDate::parse_from_str(&d, "%Y-%m-%d").ok());

    for q in agenda.klausimai {
        let title_base = q.pavadinimas.unwrap_or_else(|| "Unknown Motion".to_string());
        let project_id = q.registracijos_nr;
        let stadija = q.stadija;

        for b in q.balsavimai {
            let vid_str = b.bals_id.or(b.balsavimo_id);
            let vid = match vid_str.and_then(|s| s.parse::<i32>().ok()) {
                Some(id) => id,
                None => continue,
            };

            let r_url = format!("{}.ad_sp_balsavimo_rezultatai?balsavimo_id={}", BASE_URL, vid);
            let r_xml = client.get(&r_url).send().await?.text().await?;
            let results: ResultsRoot = from_str(&r_xml).ok().unwrap_or(ResultsRoot { antraste: None, individualus: vec![], rezultatai: vec![] });

            let mut title = title_base.clone();
            let mut current_stadija = stadija.clone();

            if let Some(ant) = results.antraste {
                if let Some(rt) = ant.klausimo_pavadinimas { title = rt; }
                if current_stadija.is_none() { current_stadija = ant.balsavimo_tipas; }
            }

            // Upsert Vote
            sqlx::query(
                "INSERT INTO votes (seimas_vote_id, sitting_date, title, project_id, vote_type)
                 VALUES ($1, $2, $3, $4, $5)
                 ON CONFLICT (seimas_vote_id) DO UPDATE SET
                    title = EXCLUDED.title,
                    sitting_date = EXCLUDED.sitting_date,
                    project_id = EXCLUDED.project_id,
                    vote_type = EXCLUDED.vote_type"
            )
            .bind(vid)
            .bind(sit_date)
            .bind(&title)
            .bind(&project_id)
            .bind(&current_stadija)
            .execute(pool)
            .await?;

            let mut ind_res = results.individualus;
            if ind_res.is_empty() { ind_res = results.rezultatai; }

            for ind in ind_res {
                let mp_ext_id = ind.asmens_id.or(ind.sn_id);
                let choice = ind.kaip_balsavo.or(ind.balsavimo_rezultatas);

                if let (Some(sid), Some(c)) = (mp_ext_id, choice) {
                    if let Some(&mp_uuid) = mp_map.get(&sid) {
                        sqlx::query(
                            "INSERT INTO mp_votes (vote_id, politician_id, vote_choice)
                             VALUES ($1, $2, $3)
                             ON CONFLICT DO NOTHING"
                        )
                        .bind(vid)
                        .bind(mp_uuid)
                        .bind(c)
                        .execute(pool)
                        .await?;
                    }
                }
            }
        }
    }
    info!("    Sitting {}: Processed.", sit_id);
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt::init();

    let database_url = std::env::var("DB_DSN").context("DB_DSN must be set")?;
    let pool = PgPool::connect(&database_url).await?;
    let client = Client::builder()
        .timeout(std::time::Duration::from_secs(30))
        .build()?;

    info!("Starting Seimas V3 Ingestion Engine (Rust)...");
    
    sync_mps(&pool, &client).await?;
    sync_votes(&pool, &client).await?;

    info!("All ingestion tasks completed successfully.");
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_normalize_name() {
        assert_eq!(normalize_name("  Vardenis   PAVARDENIS  "), "vardenis pavardenis");
        assert_eq!(normalize_name("Ąžuolas Šeškus"), "azuolas seskus");
    }

    #[test]
    fn test_build_photo_url() {
        let url = build_photo_url("Jonas", "Jonaitis");
        assert_eq!(url, "https://www.lrs.lt/SIPIS/sn_foto/2024/jonas_jonaitis.jpg");
        
        // Test with special characters
        let url2 = build_photo_url("Ąžuolas", "Šeškus");
        assert_eq!(url2, "https://www.lrs.lt/SIPIS/sn_foto/2024/azuolas_seskus.jpg");
    }
}
