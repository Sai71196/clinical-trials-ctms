-- ============================================================
-- Medical Research & Clinical Trials Management System
-- Phase 4: Sample / Seed Data (INSERT statements)
-- Realistic synthetic data — NOT real patient data
-- ============================================================

-- ============================================================
-- CLINICAL_TRIALS
-- ============================================================
INSERT INTO CLINICAL_TRIALS (Trial_Name, Trial_Phase, Start_Date, End_Date, Status, Objective, Study_Type, Inclusion_Exclusion_Criteria)
VALUES
('CARDIO-SHIELD-2024: Atorvastatin in High-Risk Patients',         'Phase III', '2024-01-15', '2026-01-14', 'Active',       'Evaluate efficacy of Atorvastatin in reducing cardiovascular events in high-risk adults.', 'Interventional', 'Include: Age 45-75, LDL > 130mg/dL. Exclude: Active liver disease, pregnancy.'),
('NEURO-RESTORE: Neuroprotection in Ischemic Stroke',              'Phase II',  '2023-06-01', '2025-05-31', 'Completed',    'Assess neuroprotective effects of NR-7 compound post-ischemic stroke onset.', 'Interventional', 'Include: Acute ischemic stroke within 6hrs. Exclude: Hemorrhagic stroke, age < 18.'),
('DIAB-PREVENT: Metformin in Pre-Diabetic Adolescents',            'Phase II',  '2024-03-01', '2026-02-28', 'Recruiting',   'Determine if early Metformin intervention prevents T2D in at-risk adolescents.', 'Interventional', 'Include: HbA1c 5.7-6.4%, Age 13-18. Exclude: Known T1D, renal impairment.'),
('ONCO-TRACK: Longitudinal Cancer Biomarker Surveillance',         'Observational','2023-01-01','2027-12-31', 'Active',      'Track plasma biomarker trajectories in Stage II-III cancer survivors over 5 years.', 'Observational',  'Include: Confirmed Stage II-III cancer, post-treatment. Exclude: Active chemotherapy.'),
('RESPIRA-CLEAR: Budesonide vs Placebo in Moderate Asthma',       'Phase III', '2024-07-01', '2026-06-30', 'Recruiting',   'Compare Budesonide inhaler to placebo for moderate persistent asthma control.', 'Interventional', 'Include: FEV1 40-79% predicted, Age 18-65. Exclude: Current smoker, COPD.'),
('COVID-LONG: Post-Acute Sequelae Symptom Management Registry',   'Phase IV',  '2022-09-01', '2025-08-31', 'Completed',    'Registry study tracking long-COVID symptom burden and interventions across cohorts.', 'Observational',  'Include: PCR-confirmed COVID, symptoms > 4 weeks post-acute. Exclude: Immunocompromised.'),
('RENAL-GUARD: SGLT2 Inhibitor in CKD Stage III',                 'Phase II',  '2025-01-10', NULL,         'Not Yet Recruiting','Investigate whether Empagliflozin slows progression from CKD Stage III to Stage IV.', 'Interventional', 'Include: eGFR 30-59, Age 30-70. Exclude: Dialysis patients, T1D.'),
('PEDS-IMMUNO: Vaccine Safety Surveillance in Toddlers 12-24mo',  'Phase IV',  '2023-11-01', '2025-10-31', 'Active',       'Passive surveillance of adverse events following MMR booster in healthy toddlers.', 'Observational',  'Include: Age 12-24 months, received MMR booster. Exclude: Known immunodeficiency.');

-- ============================================================
-- PRINCIPAL_INVESTIGATORS
-- ============================================================
INSERT INTO PRINCIPAL_INVESTIGATORS (Name, Title, Specialization, Contact_Info, Trial_ID)
VALUES
('Dr. Marcus Chen',       'MD, PhD',  'Cardiovascular Medicine',     'mchen@medresearch.edu',    1),
('Dr. Amelia Fontaine',   'MD',       'Neurology & Stroke Medicine',  'afontaine@neurolab.org',   2),
('Dr. Priya Ramanathan',  'PhD, MPH', 'Pediatric Endocrinology',      'pramanathan@unt.edu',      3),
('Dr. Samuel Okafor',     'MD, MHS',  'Oncology & Biomarker Research','sokafor@cancertrack.net',  4),
('Dr. Linda Torres',      'MD',       'Pulmonology & Allergy',        'ltorres@respiraclinic.com',5),
('Dr. Ravi Shankar',      'PhD',      'Infectious Disease & Virology','rshankar@covidlab.org',    6),
('Dr. Emily Zhao',        'MD, FASN', 'Nephrology',                   'ezhao@renalguard.edu',     7),
('Dr. Patricia Mbeki',    'MD, MPH',  'Pediatric Immunology',         'pmbeki@pediatricvax.org',  8);

-- Update CLINICAL_TRIALS with PI references
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 1 WHERE Trial_ID = 1;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 2 WHERE Trial_ID = 2;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 3 WHERE Trial_ID = 3;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 4 WHERE Trial_ID = 4;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 5 WHERE Trial_ID = 5;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 6 WHERE Trial_ID = 6;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 7 WHERE Trial_ID = 7;
UPDATE CLINICAL_TRIALS SET Principal_Investigator_ID = 8 WHERE Trial_ID = 8;

-- ============================================================
-- PATIENTS (30 synthetic patients)
-- ============================================================
INSERT INTO PATIENTS (First_Name, Last_Name, Date_of_Birth, Gender, Contact_Info, Address, Medical_History, Enrollment_Date, Trial_ID)
VALUES
('James',     'Harrison',  '1965-03-12', 'Male',   'jharrison@email.com',  '123 Oak St, Dallas TX',    'Hypertension, Hypercholesterolemia',            '2024-02-01', 1),
('Maria',     'Gonzalez',  '1970-07-28', 'Female', 'mgonzalez@email.com',  '456 Pine Ave, Plano TX',   'Type 2 Diabetes, Hyperlipidemia',               '2024-02-15', 1),
('Robert',    'Kim',       '1958-11-05', 'Male',   'rkim@email.com',       '789 Elm Dr, Frisco TX',    'CAD, Prior MI 2020',                            '2024-03-01', 1),
('Sandra',    'Patel',     '1975-04-20', 'Female', 'spatel@email.com',     '321 Cedar Ln, Allen TX',   'Hypertension, Obesity (BMI 32)',                 '2024-03-10', 1),
('Thomas',    'Washington','1980-09-15', 'Male',   'twash@email.com',      '654 Birch Rd, McKinney TX','Family Hx CAD, Smoker (former)',                 '2024-04-01', 1),
('Angela',    'Brooks',    '1960-01-30', 'Female', 'abrooks@email.com',    '987 Maple St, Garland TX', 'Ischemic stroke, HTN',                          '2023-06-15', 2),
('David',     'Nguyen',    '1972-08-22', 'Male',   'dnguyen@email.com',    '147 Walnut Blvd, Irving TX','Stroke onset 4hrs prior enrollment',           '2023-07-01', 2),
('Carmen',    'Silva',     '1968-05-11', 'Female', 'csilva@email.com',     '258 Spruce Way, Arlington TX','AF, hypertensive, cryptogenic stroke',       '2023-07-20', 2),
('Michael',   'Osei',      '2008-02-14', 'Male',   'mosei@email.com',      '369 Ash Ct, Denton TX',    'HbA1c 6.1%, family hx T2D',                     '2024-04-01', 3),
('Aisha',     'Campbell',  '2007-10-09', 'Female', 'acampbell@email.com',  '741 Poplar Dr, Lewisville TX','HbA1c 5.9%, BMI 27, PCOS',                  '2024-04-15', 3),
('Ethan',     'Rodriguez', '2009-06-25', 'Male',   'erodriguez@email.com', '852 Willow St, Flower Mound TX','HbA1c 6.3%, sedentary lifestyle',          '2024-05-01', 3),
('Priya',     'Mehta',     '1985-12-03', 'Female', 'pmehta@email.com',     '963 Oak Cliff, Dallas TX', 'Stage II breast cancer, post-lumpectomy',        '2023-02-01', 4),
('Leon',      'Fischer',   '1978-03-19', 'Male',   'lfischer@email.com',   '174 Greenway, Plano TX',   'Stage III colon cancer, post-resection',         '2023-03-15', 4),
('Nancy',     'Adeyemi',   '1990-07-07', 'Female', 'nadeyemi@email.com',   '285 Lakeside Dr, Frisco TX','Stage II cervical cancer, completed radiation', '2023-04-01', 4),
('George',    'Liu',       '1995-11-28', 'Male',   'gliu@email.com',       '396 Sunset Blvd, Mckinney TX','Moderate persistent asthma dx 2018',         '2024-08-01', 5),
('Fatima',    'Al-Hassan',  '1988-04-15', 'Female','falhassan@email.com',  '507 Crestview, Allen TX',  'Allergic asthma, seasonal rhinitis',             '2024-08-15', 5),
('Brandon',   'Scott',     '2000-09-02', 'Male',   'bscott@email.com',     '618 Hillcrest Rd, Dallas TX','Exercise-induced asthma, atopic dermatitis',   '2024-09-01', 5),
('Diana',     'Park',      '1982-06-18', 'Female', 'dpark@email.com',      '729 Lakeview, Garland TX', 'Long-COVID: fatigue, brain fog, dyspnea',        '2022-10-01', 6),
('Marcus',    'Johnson',   '1975-02-24', 'Male',   'mjohnson@email.com',   '830 Riverside, Irving TX', 'Long-COVID: POTS, chronic fatigue',              '2022-11-15', 6),
('Lily',      'Chen',      '1993-08-30', 'Female', 'lchen@email.com',      '941 Terrace Blvd, Plano TX','Long-COVID: anosmia, cognitive impairment',    '2022-12-01', 6),
('Harold',    'Diaz',      '1953-01-11', 'Male',   'hdiaz@email.com',      '102 Oakmont, Denton TX',   'CKD Stage III (eGFR 48), T2D, HTN',             '2025-01-20', 7),
('Beatrice',  'Okonkwo',   '1961-05-22', 'Female', 'bokonkwo@email.com',   '213 Willowbend, Frisco TX','CKD Stage III (eGFR 37), proteinuria',          '2025-02-01', 7),
('Toddler_A', 'Smith',     '2023-04-10', 'Male',   'parent_smith@email.com','324 Elm, Lewisville TX',  'Healthy, received MMR booster 2024-04',          '2024-05-01', 8),
('Toddler_B', 'Pham',      '2023-06-15', 'Female', 'parent_pham@email.com', '435 Maple, Mckinney TX',  'Healthy, received MMR booster 2024-06',          '2024-07-01', 8),
('Toddler_C', 'Williams',  '2023-01-20', 'Male',   'parent_williams@email.com','546 Cedar, Allen TX',  'Mild eczema, otherwise healthy',                '2024-04-01', 8),
('Samantha',  'Turner',    '1967-10-04', 'Female', 'sturner@email.com',    '657 Birchwood, Plano TX',  'Hypertension, BMI 29, sedentary',               '2024-02-20', 1),
('Kevin',     'Murphy',    '1963-07-19', 'Male',   'kmurphy@email.com',    '768 Pinecrest, Dallas TX', 'Familial hypercholesterolemia',                  '2024-03-05', 1),
('Yuki',      'Tanaka',    '1971-12-29', 'Female', 'ytanaka@email.com',    '879 Lakewood, Garland TX', 'Prior TIA, HTN, AF',                            '2023-08-01', 2),
('Carlos',    'Reyes',     '1988-03-06', 'Male',   'creyes@email.com',     '980 Oakridge, Irving TX',  'Moderate asthma, on SABA only',                 '2024-07-15', 5),
('Helen',     'Foster',    '1979-09-13', 'Female', 'hfoster@email.com',    '111 Sunflower Ln, Frisco TX','Long-COVID: sleep disorder, joint pain',      '2023-01-01', 6);

-- ============================================================
-- PATIENT_TRIALS (Enrollment records)
-- ============================================================
INSERT INTO PATIENT_TRIALS (Patient_ID, Trial_ID, Enrollment_Date, Status)
VALUES
(1, 1,'2024-02-01','Enrolled'), (2, 1,'2024-02-15','Enrolled'), (3, 1,'2024-03-01','Enrolled'),
(4, 1,'2024-03-10','Enrolled'), (5, 1,'2024-04-01','Enrolled'), (26,1,'2024-02-20','Enrolled'),
(27,1,'2024-03-05','Withdrawn'),
(6, 2,'2023-06-15','Completed'),(7, 2,'2023-07-01','Completed'),(8, 2,'2023-07-20','Completed'),
(28,2,'2023-08-01','Completed'),
(9, 3,'2024-04-01','Enrolled'), (10,3,'2024-04-15','Enrolled'), (11,3,'2024-05-01','Enrolled'),
(12,4,'2023-02-01','Enrolled'), (13,4,'2023-03-15','Enrolled'), (14,4,'2023-04-01','Enrolled'),
(15,5,'2024-08-01','Enrolled'), (16,5,'2024-08-15','Enrolled'), (17,5,'2024-09-01','Enrolled'),
(29,5,'2024-07-15','Screen Failed'),
(18,6,'2022-10-01','Completed'),(19,6,'2022-11-15','Completed'),(20,6,'2022-12-01','Completed'),
(30,6,'2023-01-01','Completed'),
(21,7,'2025-01-20','Enrolled'), (22,7,'2025-02-01','Enrolled'),
(23,8,'2024-05-01','Enrolled'), (24,8,'2024-07-01','Enrolled'), (25,8,'2024-04-01','Enrolled');

-- ============================================================
-- TRIAL_INVESTIGATORS
-- ============================================================
INSERT INTO TRIAL_INVESTIGATORS (Trial_ID, Researcher_ID, Role)
VALUES
(1,1,'Principal Investigator'),(1,2,'Co-Investigator'),
(2,2,'Principal Investigator'),(2,3,'Co-Investigator'),
(3,3,'Principal Investigator'),
(4,4,'Principal Investigator'),(4,5,'Co-Investigator'),
(5,5,'Principal Investigator'),
(6,6,'Principal Investigator'),(6,4,'Co-Investigator'),
(7,7,'Principal Investigator'),(7,1,'Co-Investigator'),
(8,8,'Principal Investigator');

-- ============================================================
-- CONSENT_FORMS
-- ============================================================
INSERT INTO CONSENT_FORMS (Patient_ID, Trial_ID, Consent_Date, Form_URL, Status, Signed_By, Version)
VALUES
(1, 1,'2024-01-28','https://storage/consent/P001_T001_v1.pdf','Active','James Harrison','v1.0'),
(2, 1,'2024-02-12','https://storage/consent/P002_T001_v1.pdf','Active','Maria Gonzalez','v1.0'),
(3, 1,'2024-02-28','https://storage/consent/P003_T001_v1.pdf','Active','Robert Kim','v1.0'),
(4, 1,'2024-03-08','https://storage/consent/P004_T001_v1.pdf','Active','Sandra Patel','v1.0'),
(5, 1,'2024-03-29','https://storage/consent/P005_T001_v1.pdf','Active','Thomas Washington','v1.0'),
(26,1,'2024-02-18','https://storage/consent/P026_T001_v1.pdf','Active','Samantha Turner','v1.0'),
(27,1,'2024-03-03','https://storage/consent/P027_T001_v1.pdf','Revoked','Kevin Murphy','v1.0'),
(6, 2,'2023-06-13','https://storage/consent/P006_T002_v1.pdf','Active','Angela Brooks','v1.0'),
(7, 2,'2023-06-29','https://storage/consent/P007_T002_v1.pdf','Active','David Nguyen','v1.0'),
(8, 2,'2023-07-18','https://storage/consent/P008_T002_v1.pdf','Active','Carmen Silva','v1.0'),
(9, 3,'2024-03-29','https://storage/consent/P009_T003_v1.pdf','Active','Guardian-Osei','v1.0'),
(10,3,'2024-04-13','https://storage/consent/P010_T003_v1.pdf','Active','Guardian-Campbell','v1.0'),
(11,3,'2024-04-29','https://storage/consent/P011_T003_v1.pdf','Active','Guardian-Rodriguez','v1.0'),
(12,4,'2023-01-29','https://storage/consent/P012_T004_v1.pdf','Active','Priya Mehta','v1.0'),
(13,4,'2023-03-13','https://storage/consent/P013_T004_v1.pdf','Active','Leon Fischer','v1.0'),
(14,4,'2023-03-30','https://storage/consent/P014_T004_v1.pdf','Active','Nancy Adeyemi','v1.0'),
(15,5,'2024-07-29','https://storage/consent/P015_T005_v1.pdf','Active','George Liu','v1.0'),
(16,5,'2024-08-13','https://storage/consent/P016_T005_v1.pdf','Active','Fatima Al-Hassan','v1.0'),
(17,5,'2024-08-29','https://storage/consent/P017_T005_v1.pdf','Active','Brandon Scott','v1.0'),
(18,6,'2022-09-29','https://storage/consent/P018_T006_v1.pdf','Active','Diana Park','v1.0'),
(19,6,'2022-11-13','https://storage/consent/P019_T006_v1.pdf','Active','Marcus Johnson','v1.0'),
(20,6,'2022-11-29','https://storage/consent/P020_T006_v1.pdf','Active','Lily Chen','v1.0'),
(21,7,'2025-01-18','https://storage/consent/P021_T007_v1.pdf','Active','Harold Diaz','v1.0'),
(22,7,'2025-01-30','https://storage/consent/P022_T007_v1.pdf','Active','Beatrice Okonkwo','v1.0');

-- ============================================================
-- LABORATORY_TESTS
-- ============================================================
INSERT INTO LABORATORY_TESTS (Test_Name, Trial_ID, Patient_ID, Test_Date, Test_Results, Lab_Name, Normal_Range, Unit, Flag)
VALUES
('LDL Cholesterol Baseline',  1,1,'2024-02-01','148','LabCorp Dallas','<100','mg/dL','High'),
('LDL Cholesterol 6-Month',   1,1,'2024-08-01','112','LabCorp Dallas','<100','mg/dL','High'),
('LDL Cholesterol 12-Month',  1,1,'2025-02-01','88', 'LabCorp Dallas','<100','mg/dL','Normal'),
('LDL Cholesterol Baseline',  1,2,'2024-02-15','162','LabCorp Dallas','<100','mg/dL','High'),
('LDL Cholesterol 6-Month',   1,2,'2024-08-15','125','LabCorp Dallas','<100','mg/dL','High'),
('NIH Stroke Scale Score',     2,6,'2023-06-15','14', 'UNT Health Center','0-42 (severity)','score','Normal'),
('NIH Stroke Scale 30-Day',    2,6,'2023-07-15','6',  'UNT Health Center','0-42','score','Normal'),
('NIH Stroke Scale Score',     2,7,'2023-07-01','18', 'UNT Health Center','0-42','score','Normal'),
('HbA1c Baseline',             3,9,'2024-04-01','6.1','Quest Diagnostics','<5.7 (normal)','%','High'),
('HbA1c 6-Month',              3,9,'2024-10-01','5.8','Quest Diagnostics','<5.7','%','Normal'),
('HbA1c Baseline',             3,10,'2024-04-15','5.9','Quest Diagnostics','<5.7','%','High'),
('CA-125 Biomarker',           4,12,'2023-02-01','22', 'Oncology Labs TX','0-35','U/mL','Normal'),
('CA-125 12-Month',            4,12,'2024-02-01','18', 'Oncology Labs TX','0-35','U/mL','Normal'),
('CEA Biomarker Baseline',     4,13,'2023-03-15','4.2','Oncology Labs TX','<3.0 (non-smoker)','ng/mL','High'),
('FEV1 % Predicted Baseline',  5,15,'2024-08-01','62', 'Pulmonary Labs TX','80-120','%','Low'),
('FEV1 % Predicted 3-Month',   5,15,'2024-11-01','71', 'Pulmonary Labs TX','80-120','%','Low'),
('FEV1 % Predicted Baseline',  5,16,'2024-08-15','58','Pulmonary Labs TX','80-120','%','Low'),
('eGFR Baseline',              7,21,'2025-01-20','48','Renal Labs TX','60+ (normal)','mL/min','Low'),
('Serum Creatinine Baseline',  7,21,'2025-01-20','1.6','Renal Labs TX','0.7-1.3 (male)','mg/dL','High'),
('eGFR Baseline',              7,22,'2025-02-01','37','Renal Labs TX','60+','mL/min','Low'),
('Adverse Event — Fever',      8,23,'2024-05-05','38.6 C / 101.5 F — resolved in 48hr','Pediatric Clinic TX','<37.5 C','°C','High'),
('Adverse Event — Local Rxn',  8,24,'2024-07-08','Redness/swelling at injection site, resolved','Pediatric Clinic TX','None','categorical','Normal');

-- ============================================================
-- REGULATORY_DOCUMENTS
-- ============================================================
INSERT INTO REGULATORY_DOCUMENTS (Document_Name, Trial_ID, Submission_Date, Approval_Status, Document_URL, Document_Type, Version, Approved_By, Approval_Date)
VALUES
('IRB Approval — CARDIO-SHIELD-2024',           1,'2023-11-01','Approved','https://docs/irb_cardio_v1.pdf',  'IRB Approval',      'v1.0','IRB Committee #7',   '2023-12-15'),
('FDA IND Application — CARDIO-SHIELD-2024',    1,'2023-10-15','Approved','https://docs/fda_cardio_v1.pdf',  'FDA IND',           'v1.0','FDA Center',         '2023-11-30'),
('HIPAA Data Security Plan — CARDIO',           1,'2023-11-20','Approved','https://docs/hipaa_cardio.pdf',   'HIPAA Compliance',  'v1.0','Privacy Officer',    '2023-12-01'),
('IRB Approval — NEURO-RESTORE',                2,'2023-03-01','Approved','https://docs/irb_neuro_v1.pdf',   'IRB Approval',      'v1.0','IRB Committee #3',   '2023-04-15'),
('FDA IND Application — NEURO-RESTORE',         2,'2023-02-15','Approved','https://docs/fda_neuro_v1.pdf',   'FDA IND',           'v1.0','FDA CDER',           '2023-04-01'),
('IRB Approval — DIAB-PREVENT',                 3,'2023-12-01','Approved','https://docs/irb_diab_v1.pdf',    'IRB Approval',      'v1.0','Pediatric IRB',      '2024-01-20'),
('Ethics Board Approval — DIAB-PREVENT',        3,'2023-12-10','Approved','https://docs/ethics_diab.pdf',    'Ethics Board',      'v1.0','UNT Ethics Board',   '2024-01-25'),
('IRB Approval — ONCO-TRACK',                   4,'2022-10-01','Approved','https://docs/irb_onco_v1.pdf',    'IRB Approval',      'v1.0','Oncology IRB',       '2022-11-15'),
('IRB Approval — RESPIRA-CLEAR',                5,'2024-04-01','Approved','https://docs/irb_resp_v1.pdf',    'IRB Approval',      'v1.0','IRB Committee #5',   '2024-05-20'),
('FDA IND Application — RESPIRA-CLEAR',         5,'2024-03-15','Approved','https://docs/fda_resp.pdf',       'FDA IND',           'v1.0','FDA CDER',           '2024-05-10'),
('IRB Approval — COVID-LONG Registry',          6,'2022-07-01','Approved','https://docs/irb_covid_v1.pdf',   'IRB Approval',      'v1.0','IRB Committee #2',   '2022-08-10'),
('IRB Approval — RENAL-GUARD',                  7,'2024-09-01','Under Review','https://docs/irb_renal_v1.pdf','IRB Approval',    'v1.0',NULL,                 NULL),
('FDA IND Application — RENAL-GUARD',           7,'2024-08-15','Under Review','https://docs/fda_renal.pdf',  'FDA IND',           'v1.0',NULL,                 NULL),
('IRB Approval — PEDS-IMMUNO',                  8,'2023-08-01','Approved','https://docs/irb_peds_v1.pdf',    'IRB Approval',      'v1.0','Pediatric IRB',      '2023-09-15');

-- ============================================================
-- FUNDING
-- ============================================================
INSERT INTO FUNDING (Trial_ID, Funding_Source, Amount, Disbursement_Date, Funding_Status, Budget_Category, Expenditure, Grant_ID)
VALUES
(1,'NIH — National Heart, Lung, Blood Institute', 2500000.00,'2024-01-15','Disbursed','Patient Care',   875000.00,'NHLBI-2024-CS-001'),
(1,'Pfizer Research Grant',                         750000.00,'2024-01-15','Disbursed','Lab Testing',    320000.00,'PFZ-RG-2024-007'),
(1,'UNT Health Science Center',                     150000.00,'2024-02-01','Disbursed','Personnel',      148000.00,'UNT-HSC-2024-003'),
(2,'NIH — National Institute of Neurological Disorders',1800000.00,'2023-06-01','Disbursed','Patient Care',1800000.00,'NINDS-2023-NR-088'),
(2,'Stroke Foundation Grant',                        400000.00,'2023-06-01','Disbursed','Lab Testing',    400000.00,'SFG-2023-011'),
(3,'NIH — NIDDK Pediatric Research',                 900000.00,'2024-03-01','Disbursed','Patient Care',   312000.00,'NIDDK-2024-DP-055'),
(3,'American Diabetes Association',                   200000.00,'2024-03-15','Disbursed','Lab Testing',    95000.00,'ADA-2024-014'),
(4,'NCI Cancer Research Grant',                      3200000.00,'2023-01-01','Disbursed','Lab Testing',  1950000.00,'NCI-2023-OT-442'),
(5,'AstraZeneca Clinical Research Fund',             1100000.00,'2024-07-01','Disbursed','Patient Care',  290000.00,'AZ-CRF-2024-889'),
(5,'American Lung Association',                        250000.00,'2024-07-15','Disbursed','Lab Testing',   87000.00,'ALA-2024-RC-033'),
(6,'CDC COVID-19 Research Initiative',                1500000.00,'2022-09-01','Disbursed','Patient Care', 1500000.00,'CDC-COVID-2022-077'),
(7,'Boehringer Ingelheim Research',                  2000000.00,'2025-01-10','Pending',  'Patient Care',       0.00,'BI-SGLT2-2025-002'),
(8,'CDC Immunization Safety Office',                   600000.00,'2023-11-01','Disbursed','Patient Care',  445000.00,'CDC-ISO-2023-099');

-- ============================================================
-- SCHEDULE
-- ============================================================
INSERT INTO SCHEDULE (Patient_ID, Trial_ID, Appointment_Date, Appointment_Type, Reminder_Status, Followup_Required, Completed)
VALUES
(1,1,'2024-02-01 09:00','Baseline',    'Y',FALSE,TRUE),
(1,1,'2024-08-01 09:00','Follow-Up',   'Y',FALSE,TRUE),
(1,1,'2025-02-01 09:00','Follow-Up',   'Y',FALSE,TRUE),
(2,1,'2024-02-15 10:00','Baseline',    'Y',FALSE,TRUE),
(2,1,'2024-08-15 10:00','Follow-Up',   'Y',TRUE, TRUE),
(6,2,'2023-06-15 08:00','Screening',   'Y',FALSE,TRUE),
(6,2,'2023-07-15 08:00','Follow-Up',   'Y',FALSE,TRUE),
(9,3,'2024-04-01 14:00','Baseline',    'Y',FALSE,TRUE),
(9,3,'2024-10-01 14:00','Follow-Up',   'Y',TRUE, TRUE),
(15,5,'2024-08-01 11:00','Baseline',   'Y',FALSE,TRUE),
(15,5,'2024-11-01 11:00','Follow-Up',  'Y',FALSE,TRUE),
(16,5,'2024-08-15 13:00','Baseline',   'Y',FALSE,TRUE),
(21,7,'2025-01-20 15:00','Baseline',   'Y',FALSE,TRUE),
(22,7,'2025-02-01 15:00','Baseline',   'Y',FALSE,FALSE),
(23,8,'2024-05-01 09:30','Screening',  'Y',TRUE, TRUE),
(24,8,'2024-07-01 09:30','Screening',  'Y',FALSE,TRUE);

-- ============================================================
-- RANDOMIZATION
-- ============================================================
INSERT INTO RANDOMIZATION (Trial_ID, Patient_ID, Patient_Group, Allocation_Date, Blinding_Status, Randomization_Code, Stratification_Factor)
VALUES
(1,1,'Treatment',    '2024-02-01','Double-Blind','RND-CS-001','LDL Stratum: 130-160'),
(1,2,'Control',      '2024-02-15','Double-Blind','RND-CS-002','LDL Stratum: 160+'),
(1,3,'Treatment',    '2024-03-01','Double-Blind','RND-CS-003','LDL Stratum: 130-160'),
(1,4,'Control',      '2024-03-10','Double-Blind','RND-CS-004','LDL Stratum: 130-160'),
(1,5,'Treatment',    '2024-04-01','Double-Blind','RND-CS-005','LDL Stratum: 130-160'),
(2,6,'Treatment',    '2023-06-15','Double-Blind','RND-NR-001','NIHSS: 10-15'),
(2,7,'Control',      '2023-07-01','Double-Blind','RND-NR-002','NIHSS: 15-20'),
(2,8,'Treatment',    '2023-07-20','Double-Blind','RND-NR-003','NIHSS: 15-20'),
(3,9,'Treatment',    '2024-04-01','Double-Blind','RND-DP-001','HbA1c: 5.7-6.0'),
(3,10,'Control',     '2024-04-15','Double-Blind','RND-DP-002','HbA1c: 5.7-6.0'),
(3,11,'Treatment',   '2024-05-01','Double-Blind','RND-DP-003','HbA1c: 6.1-6.4'),
(5,15,'Treatment',   '2024-08-01','Double-Blind','RND-RC-001','FEV1: 60-79%'),
(5,16,'Placebo',     '2024-08-15','Double-Blind','RND-RC-002','FEV1: 40-59%'),
(5,17,'Treatment',   '2024-09-01','Double-Blind','RND-RC-003','FEV1: 60-79%');

-- ============================================================
-- DRUG (Investigational Products)
-- ============================================================
INSERT INTO DRUG (Name, Type, Manufacturer, Trial_ID, Dosage, Route_of_Admin, Lot_Number, Expiry_Date, Stock_Quantity, Adverse_Events)
VALUES
('Atorvastatin 40mg',          'Drug',      'Pfizer Inc.',         1,'40mg once daily',    'Oral','LOT-ATV-2024-001','2026-12-31',480,'Mild myalgia reported in 3 patients (manageable)'),
('Placebo — Atorvastatin',     'Placebo',   'Trial Pharma LLC',    1,'Matched tablet daily','Oral','LOT-PLB-2024-001','2026-12-31',480,'None'),
('NR-7 Neuroprotective Agent', 'Drug',      'NeuroPharm Corp',     2,'15mg/kg IV bolus',   'Intravenous','LOT-NR7-2023-001','2025-06-30',0,'Transient hypotension in 1 patient, resolved.'),
('Metformin 500mg',            'Drug',      'Teva Pharmaceuticals',3,'500mg twice daily',  'Oral','LOT-MET-2024-001','2027-06-30',360,'GI discomfort in 2 adolescents (self-resolving)'),
('Budesonide 200mcg Inhaler',  'Drug',      'AstraZeneca',         5,'200mcg twice daily', 'Inhalation','LOT-BUD-2024-002','2026-08-31',200,'Mild oral candidiasis in 1 patient'),
('Placebo Inhaler',            'Placebo',   'Trial Pharma LLC',    5,'Matched device BID', 'Inhalation','LOT-PLB-2024-002','2026-08-31',200,'None'),
('Empagliflozin 10mg',         'Drug',      'Boehringer Ingelheim',7,'10mg once daily',    'Oral','LOT-EMP-2025-001','2028-01-31',250,'Not yet administered — trial pending IRB approval');
