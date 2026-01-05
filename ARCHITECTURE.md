# Seimas.v3 Architecture Documentation

## Overview

Seimas.v3 is a comprehensive system designed to provide legislative and parliamentary data management. This document outlines the architectural design, system components, and their interactions.

**Last Updated:** 2026-01-05  
**Version:** 3.0

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Principles](#architecture-principles)
3. [Core Components](#core-components)
4. [Data Model](#data-model)
5. [API Structure](#api-structure)
6. [Deployment Architecture](#deployment-architecture)
7. [Security Architecture](#security-architecture)
8. [Performance Considerations](#performance-considerations)
9. [Integration Points](#integration-points)
10. [Development Guidelines](#development-guidelines)

---

## System Overview

### Purpose
Seimas.v3 manages and provides access to Lithuanian parliamentary legislative data, including bills, amendments, voting records, and member information.

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      Client Layer                           │
│  (Web UI, Mobile App, Third-party Integrations)             │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   API Gateway / Load Balancer               │
│                  (Authentication, Rate Limiting)            │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   Service Layer                             │
│  ┌──────────────────┬──────────────────┬──────────────────┐ │
│  │ Legislative Svc  │ Member Svc       │ Voting Svc       │ │
│  │ (Bills, Amendments) │ (Representatives) │ (Records)    │ │
│  └──────────────────┴──────────────────┴──────────────────┘ │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   Data Access Layer                         │
│  (Repository Pattern, ORM, Query Optimization)              │
└────────────────────────┬────────────────────────────────────���
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   Data Storage Layer                        │
│  ┌──────────────────┬──────────────────┬──────────────────┐ │
│  │ Primary Database │ Cache Layer      │ Search Index     │ │
│  │ (PostgreSQL)     │ (Redis)          │ (Elasticsearch)  │ │
│  └──────────────────┴──────────────────┴──────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Architecture Principles

### 1. **Modularity**
- System is divided into independent, loosely coupled services
- Each service has a well-defined responsibility
- Services communicate through well-defined APIs

### 2. **Scalability**
- Horizontal scaling through microservices architecture
- Stateless service design for load distribution
- Database replication and read replicas for data layer scaling

### 3. **Maintainability**
- Clear separation of concerns
- Consistent code structure across services
- Comprehensive logging and monitoring

### 4. **Reliability**
- Redundancy at all critical layers
- Circuit breaker patterns for inter-service communication
- Comprehensive error handling and recovery mechanisms

### 5. **Security**
- Defense in depth approach
- Role-based access control (RBAC)
- Encryption at rest and in transit
- Audit logging for all sensitive operations

---

## Core Components

### 1. **API Gateway**

**Purpose:** Entry point for all client requests

**Responsibilities:**
- Request routing to appropriate services
- Authentication and authorization
- Rate limiting and throttling
- Request/response transformation
- API versioning management

**Technology Stack:**
- Kong or AWS API Gateway
- JWT token validation
- OAuth 2.0 support

**Key Features:**
- Multi-region routing
- Circuit breaker implementation
- Request logging and metrics collection

---

### 2. **Legislative Service**

**Purpose:** Manages bills, amendments, and legislative sessions

**Core Entities:**
```
Bill
├── id (UUID)
├── number (String)
├── title (String)
├── description (Text)
├── status (Enum: DRAFT, SUBMITTED, IN_DISCUSSION, APPROVED, REJECTED)
├── submittedDate (DateTime)
├── sponsoringMemberId (UUID)
├── committeeLead (UUID)
├── votingResults (One-to-Many: VotingResult)
└── amendments (One-to-Many: Amendment)

Amendment
├── id (UUID)
├── billId (UUID)
├── proposedBy (UUID)
├── content (Text)
├── status (Enum: PROPOSED, ACCEPTED, REJECTED)
├── proposedDate (DateTime)
└── comments (One-to-Many: Comment)
```

**Key APIs:**
```
GET  /api/v1/bills
POST /api/v1/bills
GET  /api/v1/bills/{billId}
PUT  /api/v1/bills/{billId}
GET  /api/v1/bills/{billId}/amendments
POST /api/v1/bills/{billId}/amendments
```

**Operations:**
- Create and update bills
- Track amendment proposals
- Manage legislative workflow
- Generate legislative reports

---

### 3. **Member Service**

**Purpose:** Manages parliamentary member information and profiles

**Core Entities:**
```
Member
├── id (UUID)
├── firstName (String)
├── lastName (String)
├── email (String, Unique)
├── phone (String)
├── partyAffiliation (String)
├── district (String)
├── joinDate (DateTime)
├── status (Enum: ACTIVE, INACTIVE, SUSPENDED)
├── roles (Many-to-Many: Role)
├── committees (Many-to-Many: Committee)
└── votingHistory (One-to-Many: VotingRecord)

Role
├── id (UUID)
├── name (String: CHAIRMAN, VICE_CHAIRMAN, COMMITTEE_MEMBER, etc.)
└── permissions (One-to-Many: Permission)
```

**Key APIs:**
```
GET  /api/v1/members
GET  /api/v1/members/{memberId}
PUT  /api/v1/members/{memberId}
GET  /api/v1/members/{memberId}/voting-history
GET  /api/v1/members/search
```

**Operations:**
- Manage member profiles
- Track committee assignments
- Record voting history
- Generate member performance reports

---

### 4. **Voting Service**

**Purpose:** Manages voting records and parliamentary decisions

**Core Entities:**
```
VotingSession
├── id (UUID)
├── billId (UUID)
├── sessionDate (DateTime)
├── status (Enum: SCHEDULED, IN_PROGRESS, COMPLETED)
├── votes (One-to-Many: Vote)
└── results (One-to-One: VotingResult)

Vote
├── id (UUID)
├── sessionId (UUID)
├── memberId (UUID)
├── decision (Enum: YES, NO, ABSTAIN)
├── timestamp (DateTime)
└── remarks (Text)

VotingResult
├── id (UUID)
├── sessionId (UUID)
├── yesCount (Integer)
├── noCount (Integer)
├── abstainCount (Integer)
├── passed (Boolean)
└── majorityCriteria (String)
```

**Key APIs:**
```
GET  /api/v1/voting-sessions
POST /api/v1/voting-sessions
GET  /api/v1/voting-sessions/{sessionId}
POST /api/v1/voting-sessions/{sessionId}/votes
GET  /api/v1/voting-sessions/{sessionId}/results
```

**Operations:**
- Record voting sessions
- Track individual votes
- Calculate voting results
- Generate statistical analyses

---

### 5. **Notification Service**

**Purpose:** Handles alerts and notifications to users

**Responsibilities:**
- Email notifications
- SMS alerts
- In-app notifications
- Push notifications (mobile)

**Configuration:**
```
NotificationTemplate
├── id (UUID)
├── type (Enum: EMAIL, SMS, PUSH)
├── name (String)
├── template (Text)
└── variables (JSON)
```

**Key APIs:**
```
POST /api/v1/notifications/send
GET  /api/v1/notifications/history
```

---

## Data Model

### Database Schema Overview

```sql
-- Users and Authentication
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Members
CREATE TABLE members (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  party_affiliation VARCHAR(100),
  district VARCHAR(100),
  join_date TIMESTAMP,
  status VARCHAR(20),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Bills
CREATE TABLE bills (
  id UUID PRIMARY KEY,
  number VARCHAR(50) UNIQUE,
  title VARCHAR(255),
  description TEXT,
  status VARCHAR(50),
  submitted_by UUID REFERENCES members(id),
  submitted_date TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Amendments
CREATE TABLE amendments (
  id UUID PRIMARY KEY,
  bill_id UUID REFERENCES bills(id),
  proposed_by UUID REFERENCES members(id),
  content TEXT,
  status VARCHAR(50),
  proposed_date TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Voting Sessions
CREATE TABLE voting_sessions (
  id UUID PRIMARY KEY,
  bill_id UUID REFERENCES bills(id),
  session_date TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Votes
CREATE TABLE votes (
  id UUID PRIMARY KEY,
  session_id UUID REFERENCES voting_sessions(id),
  member_id UUID REFERENCES members(id),
  decision VARCHAR(20),
  timestamp TIMESTAMP,
  remarks TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Voting Results
CREATE TABLE voting_results (
  id UUID PRIMARY KEY,
  session_id UUID REFERENCES voting_sessions(id),
  yes_count INTEGER,
  no_count INTEGER,
  abstain_count INTEGER,
  passed BOOLEAN,
  majority_criteria VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Indexing Strategy

```sql
-- Performance-critical indexes
CREATE INDEX idx_bills_status ON bills(status);
CREATE INDEX idx_bills_submitted_date ON bills(submitted_date DESC);
CREATE INDEX idx_votes_session_id ON votes(session_id);
CREATE INDEX idx_votes_member_id ON votes(member_id);
CREATE INDEX idx_voting_sessions_bill_id ON voting_sessions(bill_id);
CREATE INDEX idx_amendments_bill_id ON amendments(bill_id);
CREATE INDEX idx_members_status ON members(status);
```

---

## API Structure

### API Versioning

- Current version: **v1**
- All endpoints prefixed with `/api/v1`
- Support for multiple versions concurrently during migration periods

### Response Format

**Success Response (200):**
```json
{
  "success": true,
  "data": { /* Entity data */ },
  "meta": {
    "timestamp": "2026-01-05T02:52:25Z",
    "version": "1.0"
  }
}
```

**Error Response (4xx, 5xx):**
```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Descriptive error message",
    "details": { /* Additional context */ }
  },
  "meta": {
    "timestamp": "2026-01-05T02:52:25Z",
    "version": "1.0"
  }
}
```

### Authentication

- **Method:** JWT (JSON Web Tokens)
- **Header:** `Authorization: Bearer {token}`
- **Token Expiry:** 24 hours
- **Refresh Token:** 30 days

### Rate Limiting

- **Default:** 1000 requests/hour per user
- **Premium:** 5000 requests/hour
- **Headers:** 
  - `X-RateLimit-Limit`
  - `X-RateLimit-Remaining`
  - `X-RateLimit-Reset`

---

## Deployment Architecture

### Development Environment
```
┌─────────────────────────────────┐
│   Development Kubernetes Cluster │
│  ┌─────────────────────────────┐ │
│  │   Container Orchestration    │ │
│  │  - API Services             │ │
│  │  - Database (Dev)           │ │
│  │  - Cache (Dev)              │ │
│  └─────────────────────────────┘ │
└─────────────────────────────────┘
```

### Staging Environment
```
┌──────────────────────────────────┐
│  Staging Kubernetes Cluster      │
│  ┌──────────────────────────────┐ │
│  │  Multi-Replica Services      │ │
│  │  - API Services (2 replicas) │ │
│  │  - Database (Staging)        │ │
│  │  - Cache (Redis Cluster)     │ │
│  │  - Search (Elasticsearch)    │ │
│  └──────────────────────────────┘ │
└──────────────────────────────────┘
```

### Production Environment
```
┌──────────────────────────────────────────────────┐
│  Multi-Region Production Architecture            │
│                                                  │
│  Primary Region        │  Secondary Region       │
│  ┌─────────────────┐  │  ┌─────────────────┐   │
│  │ K8s Cluster     │  │  │ K8s Cluster     │   │
│  │ ┌─────────────┐ │  │  │ ┌─────────────┐ │   │
│  │ │ API (3x)    │ │  │  │ │ API (3x)    │ │   │
│  │ │ DB Primary  │ │  │  │ │ DB Replica  │ │   │
│  │ │ Redis (HA)  │ │  │  │ │ Redis (HA)  │ │   │
│  │ │ ES Cluster  │ │  │  │ │ ES Cluster  │ │   │
│  │ └─────────────┘ │  │  │ └─────────────┘ │   │
│  └─────────────────┘  │  └─────────────────┘   │
└──────────────────────────────────────────────────┘
         │ Replication & Failover │
```

### Container Orchestration

**Platform:** Kubernetes (K8s)

**Key Components:**
- **Pods:** Application containers
- **Services:** Internal and external service discovery
- **ConfigMaps:** Configuration management
- **Secrets:** Sensitive data management
- **StatefulSets:** Database and cache persistence
- **Ingress:** External traffic routing

### Deployment Pipeline

```
Code Push
    ↓
Automated Tests (Unit, Integration)
    ↓
Build Docker Images
    ↓
Push to Container Registry
    ↓
Deploy to Dev Environment
    ↓
Smoke Tests
    ↓
Deploy to Staging
    ↓
Integration & Performance Tests
    ↓
Manual Approval
    ↓
Deploy to Production (Blue-Green)
    ↓
Health Checks & Monitoring
```

---

## Security Architecture

### Defense in Depth

#### 1. **Network Security**
- **Firewall Rules:** Whitelist only necessary ports
- **VPC Isolation:** Private subnets for databases
- **WAF (Web Application Firewall):** At API Gateway
- **DDoS Protection:** Rate limiting and IP blocking

#### 2. **Authentication & Authorization**
- **Authentication:** OAuth 2.0 / OpenID Connect
- **Authorization:** RBAC (Role-Based Access Control)
- **MFA:** Multi-Factor Authentication for privileged accounts
- **Session Management:** Secure session tokens

#### 3. **Data Protection**
- **Encryption in Transit:** TLS 1.3
- **Encryption at Rest:** AES-256
- **Database:** Transparent Data Encryption (TDE)
- **Backups:** Encrypted and regularly tested

#### 4. **API Security**
- **Input Validation:** Strict schema validation
- **SQL Injection Prevention:** Parameterized queries
- **CORS:** Whitelist allowed domains
- **API Keys:** Secure key management

#### 5. **Audit & Logging**
```
┌──────────────────────────────────────┐
│      Audit Logging System            │
├──────────────────────────────────────┤
│ - User authentication events         │
│ - Sensitive data access              │
│ - Bill/amendment modifications       │
│ - Administrative actions             │
│ - Failed access attempts             │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│      Log Aggregation (ELK Stack)     │
│  - Elasticsearch                     │
│  - Logstash                          │
│  - Kibana                            │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│      SIEM Analysis                   │
│  - Anomaly Detection                 │
│  - Alert Generation                  │
│  - Compliance Reporting              │
└──────────────────────────────────────┘
```

#### 6. **Compliance**
- **GDPR:** Personal data protection
- **Audit Trail:** Complete change history
- **Data Retention:** Configurable policies
- **Right to be Forgotten:** Data deletion processes

---

## Performance Considerations

### Caching Strategy

#### 1. **Application-Level Caching (Redis)**
```
Cache Hierarchy:
├── Session Cache (TTL: 30 min)
├── User Cache (TTL: 1 hour)
├── Bill List Cache (TTL: 5 min)
├── Member Cache (TTL: 1 hour)
├── Voting Results Cache (TTL: 10 min)
└── Search Index Cache (TTL: 1 hour)
```

#### 2. **HTTP Caching**
```
Resources with Cache Headers:
├── Static Assets: max-age=31536000 (1 year)
├── API Responses: max-age=300 (5 minutes)
├── User Data: no-cache (always validate)
└── Real-time Data: no-cache
```

#### 3. **Database Query Optimization**
```
Optimization Techniques:
├── Query Analysis: EXPLAIN ANALYZE
├── Index Strategy: Composite indexes on frequently filtered columns
├── Partition Strategy: Date-based partitioning for voting records
├── Denormalization: Materialized views for reports
└── Connection Pooling: PgBouncer with 100-500 connections
```

### Monitoring & Metrics

**Key Metrics:**
```
Application Metrics:
├── Request latency (p50, p95, p99)
├── Error rate (4xx, 5xx)
├── Throughput (requests/sec)
└── Cache hit ratio

System Metrics:
├── CPU utilization
├── Memory usage
├── Disk I/O
├── Network bandwidth

Database Metrics:
├── Query execution time
├── Connection pool saturation
├── Lock contention
└── Replication lag
```

**Monitoring Tools:**
- **Prometheus:** Metrics collection
- **Grafana:** Visualization dashboards
- **New Relic / Datadog:** APM and alerting
- **ELK Stack:** Log aggregation and analysis

### Scalability Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Concurrent Users | 10,000+ | Horizontal scaling via K8s |
| Throughput | 10,000 req/sec | Load balancing across regions |
| API Response Time (p95) | < 200ms | Cache optimization, query tuning |
| Database Connections | < 500 | Connection pooling |
| Search Index Size | < 100GB | Index partitioning |

---

## Integration Points

### External Integrations

#### 1. **Government Data Sources**
- **Parliament API:** Bill submissions, voting records
- **Official Registry:** Member information validation
- **Public Records:** Legislative history

#### 2. **Third-Party Services**
- **Email Service:** SendGrid, AWS SES
- **SMS Service:** Twilio
- **Analytics:** Google Analytics, Mixpanel
- **Monitoring:** PagerDuty, Slack
- **Document Storage:** AWS S3

#### 3. **Legacy Systems**
```
Integration Layer:
┌────────────────────────────────────────┐
│     API Adapter Pattern                │
├────────────────────────────────────────┤
│ - Protocol Conversion (SOAP → REST)    │
│ - Data Mapping & Transformation        │
│ - Error Handling & Retry Logic         │
│ - Audit Trail                          │
└────────────────────────────────────────┘
         ↓
┌────────────────────────────────────────┐
│     Legacy System (SOAP-based)         │
└────────────────────────────────────────┘
```

### Event-Driven Architecture

```
Event Bus (RabbitMQ / Apache Kafka):
│
├─ bill.created
├─ bill.updated
├─ amendment.proposed
├─ vote.recorded
├─ voting_session.completed
└─ notification.sent

Subscribers:
├─ Notification Service
├─ Analytics Service
├─ Search Index Service
└─ Audit Service
```

---

## Development Guidelines

### Technology Stack

**Backend:**
- **Language:** Java/Spring Boot or Python/FastAPI
- **API Framework:** Spring Web / FastAPI
- **ORM:** Hibernate JPA / SQLAlchemy
- **Validation:** Bean Validation / Pydantic

**Database:**
- **Primary:** PostgreSQL 14+
- **Cache:** Redis 6+
- **Search:** Elasticsearch 8+

**DevOps:**
- **Containerization:** Docker
- **Orchestration:** Kubernetes
- **CI/CD:** GitHub Actions / GitLab CI
- **IaC:** Terraform / CloudFormation

**Frontend:**
- **Framework:** React 18+ / Vue 3
- **State Management:** Redux / Vuex
- **UI Library:** Material-UI / Tailwind CSS

### Code Organization

```
seimas-v3/
├── api/
│   ├── src/main/java/com/seimas/
│   │   ├── bills/
│   │   │   ├── controller/
│   │   │   ├── service/
│   │   │   ├── repository/
│   │   │   ├── entity/
│   │   │   └── dto/
│   │   ├── members/
│   │   ├── voting/
│   │   ├── notifications/
│   │   └── common/
│   └── tests/
├── infrastructure/
│   ├── kubernetes/
│   │   ├── deployments/
│   │   ├── services/
│   │   ├── configmaps/
│   │   └── ingress/
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── docker/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   └── styles/
│   └── tests/
└── docs/
    ├── ARCHITECTURE.md
    ├── API.md
    ├── DEPLOYMENT.md
    └── CONTRIBUTING.md
```

### Code Quality Standards

**Testing Requirements:**
- Unit Test Coverage: Minimum 80%
- Integration Tests: Critical paths
- E2E Tests: User workflows
- Performance Tests: Before release

**Code Review Checklist:**
- ✓ All tests pass
- ✓ Code follows style guide
- ✓ Documentation updated
- ✓ Security review (for sensitive changes)
- ✓ Performance impact assessed

### Git Workflow

```
main (production)
  ↑
  └─ release/v1.x
       ↑
       └─ develop
            ↑
            ├─ feature/bill-management
            ├─ feature/voting-system
            ├─ bugfix/session-timeout
            └─ hotfix/security-patch
```

### Deployment Checklist

- [ ] Code reviewed and merged to develop
- [ ] All automated tests passing
- [ ] Security scan completed
- [ ] Database migrations prepared
- [ ] Rollback plan documented
- [ ] Monitoring alerts configured
- [ ] Deployment window scheduled
- [ ] Stakeholders notified
- [ ] Post-deployment validation completed

---

## Future Enhancements

### Planned Features
1. **Advanced Analytics:** Machine learning for voting pattern analysis
2. **Mobile Application:** Native iOS/Android apps
3. **Real-time Collaboration:** Live bill editing and commenting
4. **Blockchain Integration:** Immutable voting records (optional)
5. **AI-Powered Search:** NLP-based bill content search
6. **Public Portal:** Enhanced citizen engagement tools

### Technology Roadmap
- Migration to event sourcing for audit trail
- GraphQL API alongside REST
- Microservices to serverless (AWS Lambda)
- Enhanced observability with distributed tracing

---

## Contact & Support

**Architecture Maintainers:** [Architecture Team]  
**Last Review Date:** 2026-01-05  
**Review Schedule:** Quarterly

For architecture questions or proposals, please submit an RFC (Request for Comment) following the project's contribution guidelines.
