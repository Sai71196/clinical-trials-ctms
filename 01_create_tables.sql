-- ============================================================
-- Medical Research & Clinical Trials Management System
-- Database: PostgreSQL
-- Phase 3: Schema Definition (DDL)
-- Project: INFO 5707 — Data Modelling for Information Professionals
-- University of North Texas | Group 3
-- ============================================================

-- Drop tables in reverse dependency order (for clean re-runs)
DROP TABLE IF EXISTS DRUG CASCADE;
DROP TABLE IF EXISTS RANDOMIZATION CASCADE;
DROP TABLE IF EXISTS FUNDING CASCADE;
DROP TABLE IF EXISTS REGULATORY_DOCUMENTS CASCADE;
DROP TABLE IF EXISTS SCHEDULE CASCADE;
DROP TABLE IF EXISTS LABORATORY_TESTS CASCADE;
DROP TABLE IF EXISTS CONSENT_FORMS CASCADE;
DROP TABLE IF EXISTS PATIENT_TRIALS CASCADE;
DROP TABLE IF EXISTS TRIAL_INVESTIGATORS CASCADE;
DROP TABLE IF EXISTS PRINCIPAL_INVESTIGATORS CASCADE;
DROP TABLE IF EXISTS PATIENTS CASCADE;
DROP TABLE IF EXISTS CLINICAL_TRIALS CASCADE;

-- ============================================================
-- 1. CLINICAL_TRIALS
-- ============================================================
CREATE TABLE CLINICAL_TRIALS (
    Trial_ID                    SERIAL PRIMARY KEY,
    Trial_Name                  VARCHAR(255) NOT NULL,
    Trial_Phase                 VARCHAR(20)  NOT NULL CHECK (Trial_Phase IN ('Phase I','Phase II','Phase III','Phase IV','Observational')),
    Start_Date                  DATE,
    End_Date                    DATE,
    Status                      VARCHAR(30)  NOT NULL DEFAULT 'Recruiting'
                                    CHECK (Status IN ('Recruiting','Active','Completed','Suspended','Terminated','Not Yet Recruiting')),
    Inclusion_Exclusion_Criteria TEXT,
    Objective                   TEXT         NOT NULL,
    Study_Type                  VARCHAR(50)  CHECK (Study_Type IN ('Interventional','Observational','Expanded Access')),
    Principal_Investigator_ID   INT,                -- FK added after PI table created
    Created_At                  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    Updated_At                  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (End_Date IS NULL OR End_Date >= Start_Date)
);

-- ============================================================
-- 2. PRINCIPAL_INVESTIGATORS
-- ============================================================
CREATE TABLE PRINCIPAL_INVESTIGATORS (
    Researcher_ID   SERIAL PRIMARY KEY,
    Name            VARCHAR(150) NOT NULL,
    Title           VARCHAR(100),
    Specialization  VARCHAR(150),
    Contact_Info    VARCHAR(255),
    Trial_ID        INT REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE SET NULL
);

-- Add FK from CLINICAL_TRIALS to PRINCIPAL_INVESTIGATORS
ALTER TABLE CLINICAL_TRIALS
    ADD CONSTRAINT fk_trial_pi
    FOREIGN KEY (Principal_Investigator_ID)
    REFERENCES PRINCIPAL_INVESTIGATORS(Researcher_ID)
    ON DELETE SET NULL;

-- ============================================================
-- 3. PATIENTS
-- ============================================================
CREATE TABLE PATIENTS (
    Patient_ID      SERIAL PRIMARY KEY,
    First_Name      VARCHAR(100) NOT NULL,
    Last_Name       VARCHAR(100) NOT NULL,
    Date_of_Birth   DATE         NOT NULL,
    Gender          VARCHAR(20)  CHECK (Gender IN ('Male','Female','Non-Binary','Prefer Not to Say')),
    Contact_Info    VARCHAR(255),
    Address         TEXT,
    Medical_History TEXT,
    Enrollment_Date DATE,
    Trial_ID        INT REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE SET NULL,
    Created_At      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. PATIENT_TRIALS (Bridge: Patients <-> Clinical_Trials M:N)
-- ============================================================
CREATE TABLE PATIENT_TRIALS (
    Patient_Trial_ID SERIAL PRIMARY KEY,
    Patient_ID       INT NOT NULL REFERENCES PATIENTS(Patient_ID) ON DELETE CASCADE,
    Trial_ID         INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Enrollment_Date  DATE NOT NULL DEFAULT CURRENT_DATE,
    Withdrawal_Date  DATE,
    Status           VARCHAR(30) DEFAULT 'Enrolled'
                         CHECK (Status IN ('Enrolled','Completed','Withdrawn','Screen Failed')),
    UNIQUE (Patient_ID, Trial_ID)
);

-- ============================================================
-- 5. TRIAL_INVESTIGATORS (Bridge: Trials <-> PIs M:N)
-- ============================================================
CREATE TABLE TRIAL_INVESTIGATORS (
    Trial_Investigator_ID SERIAL PRIMARY KEY,
    Trial_ID              INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Researcher_ID         INT NOT NULL REFERENCES PRINCIPAL_INVESTIGATORS(Researcher_ID) ON DELETE CASCADE,
    Role                  VARCHAR(100) DEFAULT 'Co-Investigator',
    UNIQUE (Trial_ID, Researcher_ID)
);

-- ============================================================
-- 6. CONSENT_FORMS
-- ============================================================
CREATE TABLE CONSENT_FORMS (
    Consent_ID    SERIAL PRIMARY KEY,
    Patient_ID    INT NOT NULL REFERENCES PATIENTS(Patient_ID) ON DELETE CASCADE,
    Trial_ID      INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Consent_Date  DATE NOT NULL DEFAULT CURRENT_DATE,
    Form_URL      TEXT,
    Status        VARCHAR(30) NOT NULL DEFAULT 'Active'
                      CHECK (Status IN ('Active','Revoked','Expired','Pending')),
    Signed_By     VARCHAR(150),
    Witnessed_By  VARCHAR(150),
    Version       VARCHAR(10) DEFAULT 'v1.0',
    Created_At    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (Patient_ID, Trial_ID, Version)
);

-- ============================================================
-- 7. LABORATORY_TESTS
-- ============================================================
CREATE TABLE LABORATORY_TESTS (
    Test_ID      SERIAL PRIMARY KEY,
    Test_Name    VARCHAR(200) NOT NULL,
    Trial_ID     INT REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE SET NULL,
    Patient_ID   INT REFERENCES PATIENTS(Patient_ID) ON DELETE SET NULL,
    Test_Date    DATE,
    Test_Results TEXT,
    Test_URL     TEXT,
    Lab_Name     VARCHAR(150),
    Normal_Range VARCHAR(100),
    Unit         VARCHAR(50),
    Flag         VARCHAR(10) CHECK (Flag IN ('Normal','High','Low','Critical',NULL))
);

-- ============================================================
-- 8. REGULATORY_DOCUMENTS
-- ============================================================
CREATE TABLE REGULATORY_DOCUMENTS (
    Document_ID     SERIAL PRIMARY KEY,
    Document_Name   VARCHAR(255) NOT NULL,
    Trial_ID        INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Submission_Date DATE,
    Approval_Status VARCHAR(30) DEFAULT 'Pending'
                        CHECK (Approval_Status IN ('Pending','Approved','Rejected','Under Review')),
    Document_URL    TEXT,
    Document_Type   VARCHAR(100) CHECK (Document_Type IN ('IRB Approval','FDA IND','HIPAA Compliance','Ethics Board','GDPR Consent','Protocol','Other')),
    Version         VARCHAR(10)  DEFAULT 'v1.0',
    Approved_By     VARCHAR(150),
    Approval_Date   DATE,
    Audit_Log       JSONB        DEFAULT '[]'::JSONB   -- stores [{user, action, timestamp}]
);

-- ============================================================
-- 9. FUNDING
-- ============================================================
CREATE TABLE FUNDING (
    Funding_ID        SERIAL PRIMARY KEY,
    Trial_ID          INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Funding_Source    VARCHAR(255) NOT NULL,
    Amount            DECIMAL(15,2) NOT NULL CHECK (Amount > 0),
    Disbursement_Date DATE,
    Funding_Status    VARCHAR(30) DEFAULT 'Pending'
                          CHECK (Funding_Status IN ('Pending','Disbursed','On Hold','Closed')),
    Budget_Category   VARCHAR(100) CHECK (Budget_Category IN ('Patient Care','Lab Testing','Personnel','Equipment','Overhead','Other')),
    Expenditure       DECIMAL(15,2) DEFAULT 0 CHECK (Expenditure >= 0),
    Grant_ID          VARCHAR(100)
);

-- ============================================================
-- 10. SCHEDULE
-- ============================================================
CREATE TABLE SCHEDULE (
    Schedule_ID       SERIAL PRIMARY KEY,
    Patient_ID        INT NOT NULL REFERENCES PATIENTS(Patient_ID) ON DELETE CASCADE,
    Trial_ID          INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Appointment_Date  TIMESTAMP NOT NULL,
    Appointment_Type  VARCHAR(100) CHECK (Appointment_Type IN ('Screening','Baseline','Follow-Up','Lab Visit','Closeout','Adverse Event Review')),
    Reminder_Status   CHAR(1) DEFAULT 'N' CHECK (Reminder_Status IN ('Y','N')),
    Followup_Required BOOLEAN DEFAULT FALSE,
    Notes             TEXT,
    Completed         BOOLEAN DEFAULT FALSE
);

-- ============================================================
-- 11. RANDOMIZATION
-- ============================================================
CREATE TABLE RANDOMIZATION (
    Randomization_ID SERIAL PRIMARY KEY,
    Trial_ID         INT NOT NULL REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE CASCADE,
    Patient_ID       INT REFERENCES PATIENTS(Patient_ID) ON DELETE SET NULL,
    Patient_Group    VARCHAR(50) NOT NULL CHECK (Patient_Group IN ('Treatment','Control','Placebo','Arm A','Arm B')),
    Allocation_Date  DATE NOT NULL DEFAULT CURRENT_DATE,
    Blinding_Status  VARCHAR(30) DEFAULT 'Open-Label'
                         CHECK (Blinding_Status IN ('Open-Label','Single-Blind','Double-Blind','Triple-Blind')),
    Randomization_Code VARCHAR(50) UNIQUE,
    Stratification_Factor TEXT
);

-- ============================================================
-- 12. DRUG (Investigational Products)
-- ============================================================
CREATE TABLE DRUG (
    Item_ID         SERIAL PRIMARY KEY,
    Name            VARCHAR(200) NOT NULL,
    Type            VARCHAR(100) CHECK (Type IN ('Drug','Biologic','Device','Placebo','Combination','Other')),
    Manufacturer    VARCHAR(200),
    Trial_ID        INT REFERENCES CLINICAL_TRIALS(Trial_ID) ON DELETE SET NULL,
    Dosage          VARCHAR(100),
    Route_of_Admin  VARCHAR(100),
    Lot_Number      VARCHAR(100),
    Expiry_Date     DATE,
    Stock_Quantity  INT DEFAULT 0 CHECK (Stock_Quantity >= 0),
    Adverse_Events  TEXT
);

-- ============================================================
-- INDEXES for query performance
-- ============================================================
CREATE INDEX idx_patients_trial    ON PATIENTS(Trial_ID);
CREATE INDEX idx_pt_patient        ON PATIENT_TRIALS(Patient_ID);
CREATE INDEX idx_pt_trial          ON PATIENT_TRIALS(Trial_ID);
CREATE INDEX idx_consent_patient   ON CONSENT_FORMS(Patient_ID);
CREATE INDEX idx_consent_trial     ON CONSENT_FORMS(Trial_ID);
CREATE INDEX idx_lab_patient       ON LABORATORY_TESTS(Patient_ID);
CREATE INDEX idx_lab_trial         ON LABORATORY_TESTS(Trial_ID);
CREATE INDEX idx_reg_trial         ON REGULATORY_DOCUMENTS(Trial_ID);
CREATE INDEX idx_funding_trial     ON FUNDING(Trial_ID);
CREATE INDEX idx_schedule_patient  ON SCHEDULE(Patient_ID);
CREATE INDEX idx_schedule_trial    ON SCHEDULE(Trial_ID);
CREATE INDEX idx_random_trial      ON RANDOMIZATION(Trial_ID);
CREATE INDEX idx_drug_trial        ON DRUG(Trial_ID);
CREATE INDEX idx_trials_status     ON CLINICAL_TRIALS(Status);

-- ============================================================
-- AUDIT TRIGGER: auto-update Updated_At on CLINICAL_TRIALS
-- ============================================================
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Updated_At = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_trials_updated
    BEFORE UPDATE ON CLINICAL_TRIALS
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ============================================================
-- VIEWS for reporting
-- ============================================================

-- Trial Enrollment Summary
CREATE OR REPLACE VIEW vw_trial_enrollment_summary AS
SELECT
    ct.Trial_ID,
    ct.Trial_Name,
    ct.Trial_Phase,
    ct.Status,
    COUNT(pt.Patient_ID) AS Total_Enrolled,
    SUM(CASE WHEN pt.Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN pt.Status = 'Withdrawn' THEN 1 ELSE 0 END) AS Withdrawn,
    SUM(CASE WHEN pt.Status = 'Screen Failed' THEN 1 ELSE 0 END) AS Screen_Failed,
    ct.Start_Date,
    ct.End_Date
FROM CLINICAL_TRIALS ct
LEFT JOIN PATIENT_TRIALS pt ON ct.Trial_ID = pt.Trial_ID
GROUP BY ct.Trial_ID, ct.Trial_Name, ct.Trial_Phase, ct.Status, ct.Start_Date, ct.End_Date;

-- Funding Utilization View
CREATE OR REPLACE VIEW vw_funding_utilization AS
SELECT
    ct.Trial_Name,
    f.Funding_Source,
    f.Budget_Category,
    f.Amount AS Allocated_Budget,
    f.Expenditure AS Amount_Spent,
    (f.Amount - f.Expenditure) AS Remaining_Budget,
    ROUND((f.Expenditure / NULLIF(f.Amount, 0)) * 100, 2) AS Pct_Utilized,
    f.Funding_Status
FROM FUNDING f
JOIN CLINICAL_TRIALS ct ON f.Trial_ID = ct.Trial_ID;

-- Consent Compliance View
CREATE OR REPLACE VIEW vw_consent_compliance AS
SELECT
    ct.Trial_Name,
    COUNT(DISTINCT pt.Patient_ID)  AS Total_Enrolled,
    COUNT(DISTINCT cf.Patient_ID)  AS Consented_Patients,
    COUNT(DISTINCT pt.Patient_ID) - COUNT(DISTINCT cf.Patient_ID) AS Missing_Consents,
    ROUND(COUNT(DISTINCT cf.Patient_ID)::NUMERIC /
          NULLIF(COUNT(DISTINCT pt.Patient_ID), 0) * 100, 2) AS Consent_Rate_Pct
FROM CLINICAL_TRIALS ct
LEFT JOIN PATIENT_TRIALS pt ON ct.Trial_ID = pt.Trial_ID
LEFT JOIN CONSENT_FORMS cf  ON ct.Trial_ID = cf.Trial_ID AND pt.Patient_ID = cf.Patient_ID
                             AND cf.Status = 'Active'
GROUP BY ct.Trial_Name;

COMMENT ON TABLE CLINICAL_TRIALS        IS 'Core table storing all clinical trial metadata and status.';
COMMENT ON TABLE PATIENTS               IS 'Patient demographic and medical history information.';
COMMENT ON TABLE PATIENT_TRIALS         IS 'Bridge table: resolves M:N between Patients and Clinical Trials.';
COMMENT ON TABLE TRIAL_INVESTIGATORS    IS 'Bridge table: resolves M:N between Trials and Principal Investigators.';
COMMENT ON TABLE CONSENT_FORMS          IS 'Stores signed consent records with version control and status tracking.';
COMMENT ON TABLE LABORATORY_TESTS       IS 'Lab test results linked to patients and trials with flagging support.';
COMMENT ON TABLE REGULATORY_DOCUMENTS   IS 'IRB, FDA, HIPAA, and other regulatory documents with audit log (JSONB).';
COMMENT ON TABLE FUNDING                IS 'Funding sources, budget allocations, and expenditure tracking per trial.';
COMMENT ON TABLE SCHEDULE               IS 'Patient appointment scheduling and follow-up tracking.';
COMMENT ON TABLE RANDOMIZATION          IS 'Randomization assignments (treatment/control/blinding) per trial.';
COMMENT ON TABLE DRUG                   IS 'Investigational product inventory, dosage, and adverse event tracking.';
