# 🧬 Medical Research & Clinical Trials Management System

**A full-cycle relational database system for managing clinical trials — from IRB approval through patient enrollment, consent tracking, lab results, regulatory compliance, funding oversight, and safety monitoring.**

> **INFO 5707 — Data Modelling for Information Professionals**  
> University of North Texas | Department of Information Science | Group 3  
> Project Coordinator: Sai Shivani Parimi

---

## 📋 Project Overview

This project designs, implements, and analyzes a **PostgreSQL-based Clinical Trial Management System (CTMS)** supporting the full data lifecycle of medical research operations. The system is built around a **12-table, 3NF-normalized schema** with bridge tables, audit trails, JSONB-based document logs, and 10 KPI analytical queries — capped with an interactive analytics dashboard.

The system was designed with real regulatory frameworks in mind: **HIPAA, GDPR, FDA 21 CFR Part 11, ICH GCP (E6), and IRB compliance requirements**.

---

## 🗂️ Repository Structure

```
clinical-trials-db/
├── sql/
│   ├── schema/
│   │   └── 01_create_tables.sql       # DDL — 12 tables, views, indexes, triggers
│   ├── data/
│   │   └── 02_seed_data.sql           # Synthetic data — 8 trials, 30 patients, full records
│   └── queries/
│       └── 03_kpi_queries.sql         # 10 analytical KPI queries + executive summary
├── dashboard/
│   └── index.html                     # Interactive analytics dashboard (Chart.js)
└── README.md
```

---

## 🏗️ Database Schema

### Tables (12)

| Table | Description | Key Relationships |
|---|---|---|
| `CLINICAL_TRIALS` | Core trial metadata, phases, status | Central hub — all other tables reference Trial_ID |
| `PATIENTS` | Demographics, medical history, enrollment | FK → CLINICAL_TRIALS |
| `PATIENT_TRIALS` | **Bridge (M:N)** — patient enrollment per trial | FK → PATIENTS + CLINICAL_TRIALS |
| `PRINCIPAL_INVESTIGATORS` | PI credentials, specialization | FK → CLINICAL_TRIALS |
| `TRIAL_INVESTIGATORS` | **Bridge (M:N)** — PI assignments per trial | FK → PI + CLINICAL_TRIALS |
| `CONSENT_FORMS` | Signed consents with version control & status | FK → PATIENTS + CLINICAL_TRIALS |
| `LABORATORY_TESTS` | Test results with normal range flagging | FK → PATIENTS + CLINICAL_TRIALS |
| `REGULATORY_DOCUMENTS` | IRB/FDA/HIPAA docs with JSONB audit log | FK → CLINICAL_TRIALS |
| `FUNDING` | Budget allocation, expenditure, burn tracking | FK → CLINICAL_TRIALS |
| `SCHEDULE` | Patient appointments and follow-up tracking | FK → PATIENTS + CLINICAL_TRIALS |
| `RANDOMIZATION` | Treatment/control group allocation, blinding | FK → CLINICAL_TRIALS |
| `DRUG` | Investigational products, inventory, adverse events | FK → CLINICAL_TRIALS |

### Database Design Highlights

- **3NF Normalization** — no transitive dependencies; all data dependencies resolved through PKs
- **2 Bridge Tables** — resolve M:N relationships (Patient↔Trial, PI↔Trial)
- **14 Indexes** — optimized for frequent join and filter patterns
- **3 Views** — `vw_trial_enrollment_summary`, `vw_funding_utilization`, `vw_consent_compliance`
- **Audit Trigger** — `BEFORE UPDATE` trigger auto-timestamps changes on `CLINICAL_TRIALS`
- **JSONB Audit Log** — `REGULATORY_DOCUMENTS.Audit_Log` stores access/modification history
- **CHECK Constraints** — enforce trial status, phase values, blinding types, and date logic

---

## 📊 KPI Queries

Ten analytical queries covering the full operational scope of a CTMS:

| # | KPI | Business Question |
|---|---|---|
| 1 | Trial Enrollment Summary | How many patients enrolled, completed, or withdrawn per trial? |
| 2 | Consent Compliance Rate | Which trials have unconsented enrolled patients? (Regulatory risk) |
| 3 | Budget Burn Rate | Which budget categories are near or over allocated spend? |
| 4 | Regulatory Doc Status | Do all active trials have approved regulatory documents? |
| 5 | Adverse Event Monitoring | Which patients have critical or abnormal lab flags requiring PI review? |
| 6 | Randomization Balance | Are treatment and control groups proportionally balanced? |
| 7 | Protocol Adherence | What % of scheduled appointments have been completed? |
| 8 | Trial Phase Portfolio | How many trials are in each phase and status? (Executive view) |
| 9 | PI Workload | How many active trials is each Principal Investigator managing? |
| 10 | Drug Safety & Inventory | Which investigational products are expiring, depleted, or flagged? |

---

## 📈 Analytics Dashboard

An interactive, browser-based dashboard (`dashboard/index.html`) visualizing all KPIs — no server required.

**Features:**
- **Overview Tab** — 6 KPI cards + trial status bar chart + phase donut + executive trial table
- **Enrollment Tab** — Per-trial enrollment bar chart, patient status donut, schedule completion bars, randomization balance chart
- **Compliance & Safety Tab** — Consent rate progress bars per trial, regulatory document status donut, full adverse event / lab flag table
- **Funding Tab** — Allocated vs spent grouped bar chart, funding source breakdown donut, budget burn rate alert bars
- **Data Model Tab** — ERD diagram (SVG), business rules, tech stack, regulatory standards covered

**To view:** Open `dashboard/index.html` in any modern browser — no dependencies to install.

---

## 🗃️ Sample Data

Synthetic data seeded across all 12 tables:

- **8 clinical trials** across 4 phases (Phase I–IV + Observational)
- **30 patients** with realistic demographics, medical histories, and trial assignments
- **8 principal investigators** with specializations and trial assignments
- **23 consent forms** with version tracking and status
- **22 lab test records** including flagged critical results
- **14 regulatory documents** (IRB, FDA IND, HIPAA, Ethics Board)
- **13 funding records** totaling ~$15.4M from NIH, pharmaceutical, and foundation sources
- **16 scheduled appointments** with completion status
- **14 randomization records** across double-blind interventional trials
- **7 drug/investigational product records** with adverse event notes

---

## 🔧 Running the Schema

### Prerequisites
- PostgreSQL 14+ (or any modern version)

### Setup

```bash
# 1. Create the database
createdb clinical_trials_db

# 2. Run schema DDL (creates all tables, indexes, views, triggers)
psql -d clinical_trials_db -f sql/schema/01_create_tables.sql

# 3. Load seed data
psql -d clinical_trials_db -f sql/data/02_seed_data.sql

# 4. Run KPI queries
psql -d clinical_trials_db -f sql/queries/03_kpi_queries.sql
```

### View the Dashboard
```bash
# Just open in browser — no server needed
open dashboard/index.html
```

---

## ⚖️ Regulatory Compliance Design

The schema was built with the following standards in mind:

| Standard | Implementation |
|---|---|
| **HIPAA** | Patient data stored in controlled tables; access modeled via role-based separation (QA, Finance, CRA, PI) |
| **GDPR** | Consent forms versioned; status tracking (Active / Revoked / Expired); patient data deletable without cascade to trial integrity |
| **FDA 21 CFR Part 11** | JSONB audit log on `REGULATORY_DOCUMENTS`; version control on all regulatory submissions |
| **ICH GCP E6** | PI oversight modeled through `TRIAL_INVESTIGATORS`; protocol adherence via `SCHEDULE` completion tracking |
| **IRB** | `REGULATORY_DOCUMENTS` enforces minimum-1-document constraint per trial before trial can be marked Active |

---

## 💡 Business Rules Implemented

1. A patient may be registered without being enrolled in any trial (optional FK)
2. A patient must sign a **separate consent form** for each trial they join
3. Each consent form is linked to **exactly one patient and one trial**
4. A clinical trial requires **at least one approved regulatory document** before proceeding
5. All regulatory documents have **version control** and a **JSONB audit trail**
6. A clinical trial can receive funding from **multiple sources**; each source is independently tracked
7. Patient appointments are linked to one patient **and** one trial
8. Randomization events are linked to one trial; not all trials are randomized (optional FK)
9. Drug records are linked to one trial; observational trials may have no drug records (optional)
10. Each PI specialization is stored independently — investigators can cover multiple trials via the bridge table

---

## 🛠️ Tech Stack

| Technology | Role |
|---|---|
| **PostgreSQL** | Primary DBMS — relational schema, constraints, triggers |
| **SQL (DDL / DML)** | Schema definition, data loading, analytical queries |
| **JSONB** | Unstructured audit log for regulatory documents |
| **HTML / CSS / JavaScript** | Interactive analytics dashboard |
| **Chart.js** | Data visualization library for dashboard |
| **GitHub** | Version control and project hosting |

---
**Live Dashboard:** https://sai71196.github.io/clinical-trials-ctms/dashboard/

## 👩‍💻 Team

| Name | Role |
|---|---|
| **Sai Shivani Parimi** | Project Coordinator · Clinical Trials Table Design · KPI Queries |
| Varsha Sane | EHR Management System Proposal · Patient Table Design |
| Sunitha Byrapaka | Dental Clinic System Proposal · Scheduling Design |
| Ria Singh | Public Health System Proposal · Regulatory Documents Design |
| Pravallika Gummadivelli | Billing System Proposal · Funding Table Design |

---

## 📬 Contact

**Sai Shivani Parimi** — Licensed Dentist (BDS) | MS Health Informatics, University of North Texas (2026)  
Clinical Informatics · EHR Systems · Healthcare Data Analytics  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/dr-sai-shivaniparimi)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black)](https://github.com/Sai71196)

---

*Academic project — all patient data is synthetic and does not represent real individuals.*
