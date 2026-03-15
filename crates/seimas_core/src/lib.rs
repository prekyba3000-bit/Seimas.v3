use chrono::{DateTime, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Politician {
    pub id: Uuid,
    pub full_name_normalized: String,
    pub display_name: String,
    pub date_of_birth: Option<NaiveDate>,
    pub seimas_mp_id: Option<i32>,
    pub vrk_candidate_id: Option<String>,
    pub open_sanctions_id: Option<String>,
    pub current_party: Option<String>,
    pub is_active: Option<bool>,
    pub term_end_date: Option<NaiveDate>,
    pub photo_url: Option<String>,
    pub alt_text: Option<serde_json::Value>,
    pub bio: Option<String>,
    pub plain_text_bio: Option<String>,
    pub bills_authored_count: Option<i32>,
    pub last_updated: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Vote {
    pub id: i32,
    pub seimas_vote_id: i32,
    pub sitting_date: Option<NaiveDate>,
    pub title: Option<String>,
    pub description: Option<String>,
    pub project_id: Option<String>,
    pub vote_type: Option<String>,
    pub result_type: Option<String>,
    pub url: Option<String>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct MpVote {
    pub id: Uuid,
    pub vote_id: i32,
    pub politician_id: Uuid,
    pub vote_choice: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone, Copy, PartialEq, Eq)]
pub enum VoteChoice {
    #[serde(rename = "Už")]
    For,
    #[serde(rename = "Prieš")]
    Against,
    #[serde(rename = "Susilaikė")]
    Abstain,
    #[serde(rename = "Nedalyvavo")]
    Absent,
}

impl From<String> for VoteChoice {
    fn from(s: String) -> Self {
        match s.as_str() {
            "Už" => VoteChoice::For,
            "Prieš" => VoteChoice::Against,
            "Susilaikė" => VoteChoice::Abstain,
            _ => VoteChoice::Absent,
        }
    }
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Asset {
    pub id: Uuid,
    pub politician_id: Option<Uuid>,
    pub year: i32,
    pub total_value: Option<rust_decimal::Decimal>,
    pub source_url: Option<String>,
    pub raw_json: Option<serde_json::Value>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Interest {
    pub id: Uuid,
    pub politician_id: Option<Uuid>,
    pub interest_type: Option<String>,
    pub description: Option<String>,
    pub organization_name: Option<String>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Speech {
    pub id: Uuid,
    pub mp_id: Option<Uuid>,
    pub session_date: Option<NaiveDate>,
    pub speech_duration_seconds: Option<i32>,
    pub words_spoken: Option<i32>,
    pub source_speech_id: Option<String>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct CommitteeMembership {
    pub id: Uuid,
    pub mp_id: Option<Uuid>,
    pub committee_name: String,
    pub role: String,
    pub start_date: Option<NaiveDate>,
    pub end_date: Option<NaiveDate>,
    pub source_duty_id: Option<String>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Amendment {
    pub id: i32,
    pub amendment_id: String,
    pub bill_id: Option<String>,
    pub proposer_mp_id: Option<Uuid>,
    pub proposed_at: Option<DateTime<Utc>>,
    pub voted_at: Option<DateTime<Utc>>,
    pub amendment_text: Option<String>,
    pub lead_time_minutes: Option<i32>,
    pub created_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct AmendmentProfile {
    pub id: i32,
    pub amendment_id: String,
    pub word_count: Option<i32>,
    pub legal_citation_count: Option<i32>,
    pub complexity_score: Option<f32>,
    pub drafting_window_minutes: Option<i32>,
    pub speed_anomaly_zscore: Option<f32>,
    pub cluster_id: Option<i32>,
    pub computed_at: Option<DateTime<Utc>>,
}
