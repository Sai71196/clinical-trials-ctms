-- ============================================================
-- Medical Research & Clinical Trials Management System
-- Phase 5: Analytical KPI Queries
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- KPI 1: Trial Enrollment Summary — Total vs Target
-- Purpose: Operations dashboard — how full is each trial?
-- Targets: Clinical Operations Team, CRAs
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_ID,
    ct.Trial_Name,
    ct.Trial_Phase,
    ct.Status,
    COUNT(pt.Patient_Trial_ID)                                          AS Total_Enrolled,
    SUM(CASE WHEN pt.Status = 'Completed'     THEN 1 ELSE 0 END)       AS Completed,
    SUM(CASE WHEN pt.Status = 'Withdrawn'     THEN 1 ELSE 0 END)       AS Withdrawn,
    SUM(CASE WHEN pt.Status = 'Screen Failed' THEN 1 ELSE 0 END)       AS Screen_Failed,
    SUM(CASE WHEN pt.Status = 'Enrolled'      THEN 1 ELSE 0 END)       AS Currently_Active,
    ROUND(
        SUM(CASE WHEN pt.Status = 'Withdrawn' THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(pt.Patient_Trial_ID), 0) * 100, 1
    )                                                                    AS Withdrawal_Rate_Pct
FROM CLINICAL_TRIALS ct
LEFT JOIN PATIENT_TRIALS pt ON ct.Trial_ID = pt.Trial_ID
GROUP BY ct.Trial_ID, ct.Trial_Name, ct.Trial_Phase, ct.Status
ORDER BY Total_Enrolled DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 2: Consent Compliance Rate per Trial
-- Purpose: Regulatory audit readiness — every enrolled patient must have a signed, active consent
-- Targets: QA Team, Regulatory Affairs
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    ct.Trial_Phase,
    COUNT(DISTINCT pt.Patient_ID)                                        AS Total_Enrolled,
    COUNT(DISTINCT CASE WHEN cf.Status = 'Active' THEN cf.Patient_ID END) AS Consented_Patients,
    COUNT(DISTINCT pt.Patient_ID)
        - COUNT(DISTINCT CASE WHEN cf.Status = 'Active' THEN cf.Patient_ID END)
                                                                         AS Missing_Consents,
    ROUND(
        COUNT(DISTINCT CASE WHEN cf.Status = 'Active' THEN cf.Patient_ID END)::NUMERIC
        / NULLIF(COUNT(DISTINCT pt.Patient_ID), 0) * 100, 1
    )                                                                    AS Consent_Rate_Pct,
    CASE
        WHEN COUNT(DISTINCT CASE WHEN cf.Status = 'Active' THEN cf.Patient_ID END)
            = COUNT(DISTINCT pt.Patient_ID) THEN 'COMPLIANT'
        ELSE 'ACTION REQUIRED'
    END                                                                  AS Compliance_Flag
FROM CLINICAL_TRIALS ct
LEFT JOIN PATIENT_TRIALS pt ON ct.Trial_ID = pt.Trial_ID
LEFT JOIN CONSENT_FORMS cf  ON pt.Patient_ID = cf.Patient_ID AND pt.Trial_ID = cf.Trial_ID
GROUP BY ct.Trial_Name, ct.Trial_Phase
ORDER BY Consent_Rate_Pct ASC;

-- ─────────────────────────────────────────────────────────────
-- KPI 3: Funding Utilization & Budget Burn Rate
-- Purpose: Financial oversight — track spend vs allocated budget per trial
-- Targets: Finance Team, Sponsors
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    f.Funding_Source,
    f.Budget_Category,
    f.Amount                                                             AS Allocated_Budget,
    f.Expenditure                                                        AS Amount_Spent,
    (f.Amount - f.Expenditure)                                          AS Remaining_Budget,
    ROUND((f.Expenditure / NULLIF(f.Amount, 0)) * 100, 1)              AS Budget_Burn_Pct,
    CASE
        WHEN (f.Expenditure / NULLIF(f.Amount, 0)) > 0.95 THEN 'CRITICAL — Near Limit'
        WHEN (f.Expenditure / NULLIF(f.Amount, 0)) > 0.75 THEN 'WARNING — Monitor'
        ELSE 'ON TRACK'
    END                                                                  AS Budget_Alert
FROM FUNDING f
JOIN CLINICAL_TRIALS ct ON f.Trial_ID = ct.Trial_ID
ORDER BY Budget_Burn_Pct DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 4: Regulatory Document Status per Trial
-- Purpose: Compliance gate — no trial should run without approved regulatory docs
-- Targets: Regulatory Affairs, QA
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    ct.Status                                                            AS Trial_Status,
    COUNT(rd.Document_ID)                                               AS Total_Documents,
    SUM(CASE WHEN rd.Approval_Status = 'Approved'     THEN 1 ELSE 0 END) AS Approved,
    SUM(CASE WHEN rd.Approval_Status = 'Under Review' THEN 1 ELSE 0 END) AS Under_Review,
    SUM(CASE WHEN rd.Approval_Status = 'Pending'      THEN 1 ELSE 0 END) AS Pending,
    SUM(CASE WHEN rd.Approval_Status = 'Rejected'     THEN 1 ELSE 0 END) AS Rejected,
    ROUND(
        SUM(CASE WHEN rd.Approval_Status = 'Approved' THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(rd.Document_ID), 0) * 100, 1
    )                                                                    AS Doc_Approval_Rate_Pct
FROM CLINICAL_TRIALS ct
LEFT JOIN REGULATORY_DOCUMENTS rd ON ct.Trial_ID = rd.Trial_ID
GROUP BY ct.Trial_Name, ct.Status
ORDER BY Doc_Approval_Rate_Pct ASC;

-- ─────────────────────────────────────────────────────────────
-- KPI 5: Adverse Event / Critical Lab Flag Summary
-- Purpose: Patient safety monitoring — flag critical lab results
-- Targets: Principal Investigators, Safety Monitoring Board
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    ct.Trial_Phase,
    p.First_Name || ' ' || p.Last_Name                                  AS Patient_Name,
    lt.Test_Name,
    lt.Test_Date,
    lt.Test_Results,
    lt.Unit,
    lt.Normal_Range,
    lt.Flag,
    CASE WHEN lt.Flag = 'Critical' THEN 'IMMEDIATE ACTION'
         WHEN lt.Flag = 'High'     THEN 'REVIEW REQUIRED'
         WHEN lt.Flag = 'Low'      THEN 'REVIEW REQUIRED'
         ELSE 'OK'
    END                                                                  AS Action_Required
FROM LABORATORY_TESTS lt
JOIN PATIENTS p         ON lt.Patient_ID = p.Patient_ID
JOIN CLINICAL_TRIALS ct ON lt.Trial_ID   = ct.Trial_ID
WHERE lt.Flag IN ('Critical','High','Low')
ORDER BY lt.Test_Date DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 6: Randomization Balance Check
-- Purpose: Trial integrity — ensure treatment/control groups are balanced
-- Targets: Biostatistics, PI
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    r.Blinding_Status,
    r.Patient_Group,
    COUNT(r.Randomization_ID)                                           AS N_Assigned,
    ROUND(
        COUNT(r.Randomization_ID)::NUMERIC
        / SUM(COUNT(r.Randomization_ID)) OVER (PARTITION BY r.Trial_ID) * 100, 1
    )                                                                    AS Group_Proportion_Pct
FROM RANDOMIZATION r
JOIN CLINICAL_TRIALS ct ON r.Trial_ID = ct.Trial_ID
GROUP BY ct.Trial_Name, r.Blinding_Status, r.Patient_Group, r.Trial_ID
ORDER BY ct.Trial_Name, r.Patient_Group;

-- ─────────────────────────────────────────────────────────────
-- KPI 7: Patient Protocol Adherence — Appointment Completion Rate
-- Purpose: Track whether enrolled patients are completing scheduled visits
-- Targets: CRAs, Clinical Operations Team
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    COUNT(s.Schedule_ID)                                                AS Total_Appointments,
    SUM(CASE WHEN s.Completed = TRUE  THEN 1 ELSE 0 END)               AS Completed,
    SUM(CASE WHEN s.Completed = FALSE THEN 1 ELSE 0 END)               AS Pending_or_Missed,
    SUM(CASE WHEN s.Followup_Required = TRUE  THEN 1 ELSE 0 END)       AS Followup_Needed,
    ROUND(
        SUM(CASE WHEN s.Completed = TRUE THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(s.Schedule_ID), 0) * 100, 1
    )                                                                    AS Completion_Rate_Pct
FROM SCHEDULE s
JOIN CLINICAL_TRIALS ct ON s.Trial_ID = ct.Trial_ID
GROUP BY ct.Trial_Name
ORDER BY Completion_Rate_Pct ASC;

-- ─────────────────────────────────────────────────────────────
-- KPI 8: Trial Phase Portfolio Overview
-- Purpose: Executive dashboard — how many trials per phase and status
-- Targets: Leadership, Research Directors
-- ─────────────────────────────────────────────────────────────
SELECT
    Trial_Phase,
    COUNT(*)                                                            AS Total_Trials,
    SUM(CASE WHEN Status = 'Active'           THEN 1 ELSE 0 END)       AS Active,
    SUM(CASE WHEN Status = 'Recruiting'       THEN 1 ELSE 0 END)       AS Recruiting,
    SUM(CASE WHEN Status = 'Completed'        THEN 1 ELSE 0 END)       AS Completed,
    SUM(CASE WHEN Status = 'Not Yet Recruiting' THEN 1 ELSE 0 END)     AS Not_Started,
    SUM(CASE WHEN Status IN ('Suspended','Terminated') THEN 1 ELSE 0 END) AS Stopped
FROM CLINICAL_TRIALS
GROUP BY Trial_Phase
ORDER BY Trial_Phase;

-- ─────────────────────────────────────────────────────────────
-- KPI 9: Principal Investigator Workload
-- Purpose: Resource management — how many active trials per PI?
-- Targets: Research Administration
-- ─────────────────────────────────────────────────────────────
SELECT
    pi.Name                                                             AS PI_Name,
    pi.Specialization,
    COUNT(DISTINCT ti.Trial_ID)                                         AS Total_Trials,
    COUNT(DISTINCT CASE WHEN ct.Status = 'Active'     THEN ti.Trial_ID END) AS Active_Trials,
    COUNT(DISTINCT CASE WHEN ct.Status = 'Recruiting' THEN ti.Trial_ID END) AS Recruiting_Trials,
    COUNT(DISTINCT CASE WHEN ct.Status = 'Completed'  THEN ti.Trial_ID END) AS Completed_Trials,
    STRING_AGG(ct.Trial_Name, ' | ')                                    AS Trial_Names
FROM PRINCIPAL_INVESTIGATORS pi
JOIN TRIAL_INVESTIGATORS ti ON pi.Researcher_ID = ti.Researcher_ID
JOIN CLINICAL_TRIALS ct     ON ti.Trial_ID = ct.Trial_ID
GROUP BY pi.Name, pi.Specialization
ORDER BY Total_Trials DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 10: Drug Inventory & Adverse Event Summary
-- Purpose: Drug safety and supply chain monitoring
-- Targets: Pharmacovigilance, Safety Board
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    d.Name                                                              AS Drug_Name,
    d.Type,
    d.Manufacturer,
    d.Dosage,
    d.Route_of_Admin,
    d.Stock_Quantity                                                    AS Remaining_Stock,
    d.Expiry_Date,
    CASE
        WHEN d.Expiry_Date < CURRENT_DATE THEN 'EXPIRED'
        WHEN d.Expiry_Date < CURRENT_DATE + INTERVAL '90 days' THEN 'EXPIRING SOON'
        ELSE 'OK'
    END                                                                  AS Expiry_Alert,
    d.Adverse_Events
FROM DRUG d
JOIN CLINICAL_TRIALS ct ON d.Trial_ID = ct.Trial_ID
ORDER BY d.Expiry_Date ASC;

-- ─────────────────────────────────────────────────────────────
-- BONUS — Total Funding by Trial (Executive Summary)
-- ─────────────────────────────────────────────────────────────
SELECT
    ct.Trial_Name,
    ct.Trial_Phase,
    ct.Status,
    SUM(f.Amount)                                                       AS Total_Allocated,
    SUM(f.Expenditure)                                                  AS Total_Spent,
    SUM(f.Amount - f.Expenditure)                                       AS Total_Remaining,
    ROUND(SUM(f.Expenditure) / NULLIF(SUM(f.Amount), 0) * 100, 1)      AS Overall_Burn_Pct
FROM CLINICAL_TRIALS ct
JOIN FUNDING f ON ct.Trial_ID = f.Trial_ID
GROUP BY ct.Trial_Name, ct.Trial_Phase, ct.Status
ORDER BY Total_Allocated DESC;
