-- ============================================================
-- COMP 102 – INTRODUCTION TO DATABASE | FINAL GROUP PROJECT
-- Project Title: Public Health Clinic Records System
-- SDG 3: Good Health and Well-being
-- Class: B3SEM1205F
-- ============================================================

-- ============================================================
-- SECTION 1: DATABASE CREATION
-- ============================================================

-- Disable strict mode to ensure compatibility with all MySQL versions
SET GLOBAL sql_mode = '';
SET SESSION sql_mode = '';

DROP DATABASE IF EXISTS public_health_clinic;
CREATE DATABASE public_health_clinic;
USE public_health_clinic;

-- ============================================================
-- SECTION 2: TABLE CREATION WITH CONSTRAINTS
-- ============================================================

-- Table 1: PATIENTS
CREATE TABLE PATIENTS (
    Patient_ID      INT             NOT NULL AUTO_INCREMENT,
    Full_Name       VARCHAR(100)    NOT NULL,
    Date_of_Birth   DATE            NOT NULL,
    Gender          VARCHAR(10)     NOT NULL,
    Phone_Number    VARCHAR(20)     NOT NULL,
    Address         VARCHAR(150)    NOT NULL,
    Blood_Type      VARCHAR(5)      NULL DEFAULT NULL,
    CONSTRAINT pk_patients PRIMARY KEY (Patient_ID)
);

-- Table 2: DOCTORS
CREATE TABLE DOCTORS (
    Doctor_ID       INT             NOT NULL AUTO_INCREMENT,
    Full_Name       VARCHAR(100)    NOT NULL,
    Specialization  VARCHAR(100)    NOT NULL,
    Phone_Number    VARCHAR(20)     NOT NULL,
    Email           VARCHAR(100)    NOT NULL,
    License_Number  VARCHAR(50)     NOT NULL UNIQUE,
    CONSTRAINT pk_doctors PRIMARY KEY (Doctor_ID)
);

-- Table 3: APPOINTMENTS
CREATE TABLE APPOINTMENTS (
    Appointment_ID  INT             NOT NULL AUTO_INCREMENT,
    Patient_ID      INT             NOT NULL,
    Doctor_ID       INT             NOT NULL,
    Appointment_Date DATE           NOT NULL,
    Appointment_Time TIME           NOT NULL,
    Reason          VARCHAR(200)    NOT NULL,
    Status          VARCHAR(30)     DEFAULT 'Scheduled',
    CONSTRAINT pk_appointments PRIMARY KEY (Appointment_ID),
    CONSTRAINT fk_appt_patient FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID),
    CONSTRAINT fk_appt_doctor  FOREIGN KEY (Doctor_ID)  REFERENCES DOCTORS(Doctor_ID)
);

-- Table 4: MEDICAL_RECORDS
CREATE TABLE MEDICAL_RECORDS (
    Record_ID       INT             NOT NULL AUTO_INCREMENT,
    Patient_ID      INT             NOT NULL,
    Doctor_ID       INT             NOT NULL,
    Visit_Date      DATE            NOT NULL,
    Diagnosis       VARCHAR(200)    NOT NULL,
    Treatment       VARCHAR(200)    NOT NULL,
    Notes           VARCHAR(300)    DEFAULT NULL,
    CONSTRAINT pk_records PRIMARY KEY (Record_ID),
    CONSTRAINT fk_rec_patient FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID),
    CONSTRAINT fk_rec_doctor  FOREIGN KEY (Doctor_ID)  REFERENCES DOCTORS(Doctor_ID)
);

-- Table 5: PRESCRIPTIONS
CREATE TABLE PRESCRIPTIONS (
    Prescription_ID INT             NOT NULL AUTO_INCREMENT,
    Record_ID       INT             NOT NULL,
    Medication_Name VARCHAR(100)    NOT NULL,
    Dosage          VARCHAR(50)     NOT NULL,
    Duration        VARCHAR(50)     NOT NULL,
    Instructions    VARCHAR(200)    DEFAULT 'Take as directed',
    CONSTRAINT pk_prescriptions PRIMARY KEY (Prescription_ID),
    CONSTRAINT fk_presc_record FOREIGN KEY (Record_ID) REFERENCES MEDICAL_RECORDS(Record_ID)
);

-- Table 6: BILLING
CREATE TABLE BILLING (
    Bill_ID         INT             NOT NULL AUTO_INCREMENT,
    Patient_ID      INT             NOT NULL,
    Appointment_ID  INT             NOT NULL,
    Amount          DECIMAL(10,2)   NOT NULL,
    Bill_Date       DATE            NOT NULL,
    Payment_Status  VARCHAR(30)     DEFAULT 'Unpaid',
    Payment_Method  VARCHAR(50)     DEFAULT NULL,
    CONSTRAINT pk_billing PRIMARY KEY (Bill_ID),
    CONSTRAINT fk_bill_patient FOREIGN KEY (Patient_ID)     REFERENCES PATIENTS(Patient_ID),
    CONSTRAINT fk_bill_appt   FOREIGN KEY (Appointment_ID)  REFERENCES APPOINTMENTS(Appointment_ID)
);


-- ============================================================
-- SECTION 3: SAMPLE DATA INSERTION
-- ============================================================

-- Insert Patients
INSERT INTO PATIENTS (Full_Name, Date_of_Birth, Gender, Phone_Number, Address, Blood_Type) VALUES
('Aminata Koroma',     '1990-03-15', 'Female', '076123456', '12 Wellington Street, Freetown',    'O+'),
('Mohamed Sesay',      '1985-07-22', 'Male',   '077234567', '5 Lumley Beach Road, Freetown',     'A+'),
('Fatmata Kamara',     '2000-11-05', 'Female', '078345678', '34 Circular Road, Freetown',        'B+'),
('Ibrahim Bangura',    '1978-01-30', 'Male',   '079456789', '8 Sanders Street, Freetown',        'AB+'),
('Mariama Conteh',     '1995-06-18', 'Female', '076567890', '21 Campbell Street, Freetown',      'O-'),
('Samuel Johnson',     '1968-09-10', 'Male',   '077678901', '3 Siaka Stevens Street, Freetown',  'A-'),
('Isatu Turay',        '2003-04-25', 'Female', '078789012', '17 Congo Cross, Freetown',          'B-'),
('Abdul Jalloh',       '1992-12-01', 'Male',   '079890123', '6 Spur Road, Freetown',             'O+'),
('Hawa Mansaray',      '1975-08-14', 'Female', '076901234', '29 King Street, Freetown',          'A+'),
('David Cole',         '1988-02-20', 'Male',   '077012345', '11 Charlotte Street, Freetown',     'AB-');

-- Insert Doctors
INSERT INTO DOCTORS (Full_Name, Specialization, Phone_Number, Email, License_Number) VALUES
('Dr. Emmanuel Bangura',    'General Medicine',  '076111222', 'e.bangura@clinic.sl',   'SL-DOC-0021'),
('Dr. Grace Koroma',        'Pediatrics',        '077222333', 'g.koroma@clinic.sl',    'SL-DOC-0035'),
('Dr. James Sesay',         'Surgery',           '078333444', 'j.sesay@clinic.sl',     'SL-DOC-0048'),
('Dr. Patricia Kamara',     'Obstetrics',        '079444555', 'p.kamara@clinic.sl',    'SL-DOC-0059'),
('Dr. Robert Conteh',       'Cardiology',        '076555666', 'r.conteh@clinic.sl',    'SL-DOC-0067');

-- Insert Appointments
INSERT INTO APPOINTMENTS (Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Reason, Status) VALUES
(1,  1, '2026-06-01', '09:00:00', 'Persistent headache and fever',         'Completed'),
(2,  2, '2026-06-01', '10:00:00', 'Child routine checkup',                 'Completed'),
(3,  4, '2026-06-02', '11:00:00', 'Prenatal checkup',                      'Completed'),
(4,  5, '2026-06-02', '14:00:00', 'Chest pain evaluation',                 'Completed'),
(5,  1, '2026-06-03', '09:30:00', 'Follow-up for malaria treatment',       'Completed'),
(6,  3, '2026-06-05', '08:00:00', 'Hernia consultation',                   'Completed'),
(7,  2, '2026-06-08', '10:30:00', 'Child vaccination',                     'Completed'),
(8,  1, '2026-06-10', '11:00:00', 'General checkup',                       'Completed'),
(9,  5, '2026-06-15', '13:00:00', 'High blood pressure review',            'Completed'),
(10, 3, '2026-06-18', '15:00:00', 'Appendicitis consultation',             'Completed'),
(1,  1, '2026-07-01', '09:00:00', 'Routine follow-up',                     'Scheduled'),
(3,  4, '2026-07-03', '11:00:00', 'Second trimester prenatal',             'Scheduled');

-- Insert Medical Records
INSERT INTO MEDICAL_RECORDS (Patient_ID, Doctor_ID, Visit_Date, Diagnosis, Treatment, Notes) VALUES
(1,  1, '2026-06-01', 'Malaria',                 'Artemether-Lumefantrine course',         'Patient advised bed rest and hydration'),
(2,  2, '2026-06-01', 'Healthy – no issues',     'No treatment required',                  'All vitals normal for age'),
(3,  4, '2026-06-02', 'Normal pregnancy – 20wk', 'Iron and folic acid supplements',        'Fetal heartbeat normal'),
(4,  5, '2026-06-02', 'Hypertension Stage 2',    'Amlodipine 10mg daily',                  'Patient referred for ECG'),
(5,  1, '2026-06-03', 'Malaria – follow-up',     'Continue AL therapy',                    'Patient improving; fever reduced'),
(6,  3, '2026-06-05', 'Inguinal Hernia',         'Surgical repair scheduled',              'Pre-op tests ordered'),
(7,  2, '2026-06-08', 'Healthy child',           'DPT booster administered',               'Next vaccination due in 3 months'),
(8,  1, '2026-06-10', 'Common Cold',             'Rest, paracetamol, fluids',              'No prescription required'),
(9,  5, '2026-06-15', 'Hypertension – chronic',  'Lisinopril 5mg + lifestyle changes',     'Patient counselled on diet'),
(10, 3, '2026-06-18', 'Acute Appendicitis',      'Emergency appendectomy performed',       'Successful surgery; recovery ward');

-- Insert Prescriptions
INSERT INTO PRESCRIPTIONS (Record_ID, Medication_Name, Dosage, Duration, Instructions) VALUES
(1,  'Artemether-Lumefantrine', '4 tablets',  '3 days',   'Take with food twice daily'),
(3,  'Ferrous Sulphate',        '200mg',      '6 months', 'Take once daily with orange juice'),
(3,  'Folic Acid',              '5mg',        '6 months', 'Take once daily in the morning'),
(4,  'Amlodipine',              '10mg',       '30 days',  'Take once daily at same time'),
(5,  'Artemether-Lumefantrine', '4 tablets',  '3 days',   'Complete full course'),
(9,  'Lisinopril',              '5mg',        '30 days',  'Take in the morning with water'),
(9,  'Hydrochlorothiazide',     '12.5mg',     '30 days',  'Take in the morning'),
(10, 'Amoxicillin',             '500mg',      '7 days',   'Take 3 times daily after meals'),
(10, 'Paracetamol',             '1000mg',     '5 days',   'Take every 8 hours for pain');

-- Insert Billing
INSERT INTO BILLING (Patient_ID, Appointment_ID, Amount, Bill_Date, Payment_Status, Payment_Method) VALUES
(1,  1,  50000.00,  '2026-06-01', 'Paid',    'Cash'),
(2,  2,  30000.00,  '2026-06-01', 'Paid',    'Mobile Money'),
(3,  3,  45000.00,  '2026-06-02', 'Paid',    'Cash'),
(4,  4,  75000.00,  '2026-06-02', 'Unpaid',  NULL),
(5,  5,  25000.00,  '2026-06-03', 'Paid',    'Cash'),
(6,  6,  150000.00, '2026-06-05', 'Unpaid',  NULL),
(7,  7,  20000.00,  '2026-06-08', 'Paid',    'Mobile Money'),
(8,  8,  15000.00,  '2026-06-10', 'Paid',    'Cash'),
(9,  9,  60000.00,  '2026-06-15', 'Unpaid',  NULL),
(10, 10, 200000.00, '2026-06-18', 'Paid',    'Bank Transfer');


-- ============================================================
-- SECTION 4: DATA MANIPULATION (UPDATE & DELETE)
-- ============================================================

-- UPDATE: Mark Ibrahim Bangura's bill as Paid
UPDATE BILLING
SET Payment_Status = 'Paid', Payment_Method = 'Mobile Money'
WHERE Bill_ID = 4;

-- UPDATE: Update Doctor Grace Koroma's phone number
UPDATE DOCTORS
SET Phone_Number = '077999888'
WHERE Doctor_ID = 2;

-- UPDATE: Change appointment status to Cancelled
UPDATE APPOINTMENTS
SET Status = 'Cancelled'
WHERE Appointment_ID = 12;

-- DELETE: Remove a cancelled appointment record (safe delete example)
DELETE FROM APPOINTMENTS
WHERE Appointment_ID = 12 AND Status = 'Cancelled';


-- ============================================================
-- SECTION 5: SQL QUERIES
-- ============================================================

-- Query 1: SELECT all patients (basic SELECT)
SELECT * FROM PATIENTS;

-- Query 2: SELECT all doctors with their specializations
SELECT Doctor_ID, Full_Name, Specialization, Phone_Number FROM DOCTORS;

-- Query 3: WHERE – Find all female patients
SELECT Full_Name, Date_of_Birth, Phone_Number, Address
FROM PATIENTS
WHERE Gender = 'Female';

-- Query 4: WHERE – Find all unpaid bills
SELECT b.Bill_ID, p.Full_Name, b.Amount, b.Bill_Date, b.Payment_Status
FROM BILLING b
JOIN PATIENTS p ON b.Patient_ID = p.Patient_ID
WHERE b.Payment_Status = 'Unpaid';

-- Query 5: WHERE – Find appointments with status 'Completed'
SELECT a.Appointment_ID, p.Full_Name AS Patient, d.Full_Name AS Doctor,
       a.Appointment_Date, a.Reason, a.Status
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.Patient_ID = p.Patient_ID
JOIN DOCTORS  d ON a.Doctor_ID  = d.Doctor_ID
WHERE a.Status = 'Completed';

-- Query 6: ORDER BY – List patients sorted by Full Name A-Z
SELECT Patient_ID, Full_Name, Gender, Phone_Number
FROM PATIENTS
ORDER BY Full_Name ASC;

-- Query 7: ORDER BY – List bills from highest to lowest amount
SELECT b.Bill_ID, p.Full_Name, b.Amount, b.Payment_Status
FROM BILLING b
JOIN PATIENTS p ON b.Patient_ID = p.Patient_ID
ORDER BY b.Amount DESC;

-- Query 8: ORDER BY – Medical records sorted by most recent visit
SELECT mr.Record_ID, p.Full_Name, d.Full_Name AS Doctor,
       mr.Visit_Date, mr.Diagnosis
FROM MEDICAL_RECORDS mr
JOIN PATIENTS p ON mr.Patient_ID = p.Patient_ID
JOIN DOCTORS  d ON mr.Doctor_ID  = d.Doctor_ID
ORDER BY mr.Visit_Date DESC;

-- Query 9: COUNT – Total number of patients registered
SELECT COUNT(*) AS Total_Patients FROM PATIENTS;

-- Query 10: COUNT – Total appointments per doctor
SELECT d.Full_Name AS Doctor, COUNT(a.Appointment_ID) AS Total_Appointments
FROM DOCTORS d
LEFT JOIN APPOINTMENTS a ON d.Doctor_ID = a.Doctor_ID
GROUP BY d.Doctor_ID, d.Full_Name
ORDER BY Total_Appointments DESC;

-- Query 11: SUM – Total revenue collected from paid bills
SELECT SUM(Amount) AS Total_Revenue_Collected
FROM BILLING
WHERE Payment_Status = 'Paid';

-- Query 12: SUM – Total outstanding (unpaid) amount
SELECT SUM(Amount) AS Total_Outstanding
FROM BILLING
WHERE Payment_Status = 'Unpaid';

-- Query 13: SUM – Total billing amount per patient
SELECT p.Full_Name AS Patient, SUM(b.Amount) AS Total_Billed
FROM BILLING b
JOIN PATIENTS p ON b.Patient_ID = p.Patient_ID
GROUP BY b.Patient_ID, p.Full_Name
ORDER BY Total_Billed DESC;

-- Query 14: AVG – Average consultation bill amount
SELECT AVG(Amount) AS Average_Bill FROM BILLING;

-- Query 15: LIMIT – Show the 5 most recent medical records
SELECT mr.Record_ID, p.Full_Name, d.Full_Name AS Doctor,
       mr.Visit_Date, mr.Diagnosis, mr.Treatment
FROM MEDICAL_RECORDS mr
JOIN PATIENTS p ON mr.Patient_ID = p.Patient_ID
JOIN DOCTORS  d ON mr.Doctor_ID  = d.Doctor_ID
ORDER BY mr.Visit_Date DESC
LIMIT 5;

-- Query 16: LIMIT – Top 3 highest bills
SELECT p.Full_Name, b.Amount, b.Bill_Date, b.Payment_Status
FROM BILLING b
JOIN PATIENTS p ON b.Patient_ID = p.Patient_ID
ORDER BY b.Amount DESC
LIMIT 3;

-- Query 17: Real-life scenario – Patients with outstanding bills and diagnosis
SELECT p.Full_Name AS Patient, p.Phone_Number,
       mr.Diagnosis, b.Amount AS Bill_Amount, b.Payment_Status
FROM BILLING b
JOIN PATIENTS p       ON b.Patient_ID = p.Patient_ID
JOIN APPOINTMENTS a   ON b.Appointment_ID = a.Appointment_ID
JOIN MEDICAL_RECORDS mr ON (mr.Patient_ID = p.Patient_ID AND mr.Visit_Date = a.Appointment_Date)
WHERE b.Payment_Status = 'Unpaid'
ORDER BY b.Amount DESC;

-- Query 18: Real-life scenario – All prescriptions for a specific patient (Aminata Koroma)
SELECT p.Full_Name AS Patient, pr.Medication_Name, pr.Dosage,
       pr.Duration, pr.Instructions
FROM PRESCRIPTIONS pr
JOIN MEDICAL_RECORDS mr ON pr.Record_ID = mr.Record_ID
JOIN PATIENTS p          ON mr.Patient_ID = p.Patient_ID
WHERE p.Full_Name = 'Aminata Koroma';

-- Query 19: Real-life scenario – Doctors and total patients treated
SELECT d.Full_Name AS Doctor, d.Specialization,
       COUNT(DISTINCT mr.Patient_ID) AS Patients_Treated
FROM DOCTORS d
LEFT JOIN MEDICAL_RECORDS mr ON d.Doctor_ID = mr.Doctor_ID
GROUP BY d.Doctor_ID, d.Full_Name, d.Specialization
ORDER BY Patients_Treated DESC;

-- Query 20: Real-life scenario – Blood type distribution among patients
SELECT Blood_Type, COUNT(*) AS Count
FROM PATIENTS
GROUP BY Blood_Type
ORDER BY Count DESC;


-- ============================================================
-- SECTION 6: USER MANAGEMENT
-- ============================================================

-- Create user accounts (replace localhost with % for network access if needed)
CREATE USER IF NOT EXISTS 'emeric_walter'@'localhost'     IDENTIFIED BY 'Emeric@2026';
CREATE USER IF NOT EXISTS 'group_member2'@'localhost'     IDENTIFIED BY 'Member2@2026';
CREATE USER IF NOT EXISTS 'group_member3'@'localhost'     IDENTIFIED BY 'Member3@2026';
CREATE USER IF NOT EXISTS 'clinic_admin'@'localhost'      IDENTIFIED BY 'Admin@Clinic2026';
CREATE USER IF NOT EXISTS 'clinic_readonly'@'localhost'   IDENTIFIED BY 'ReadOnly@2026';

-- Change password example
ALTER USER 'group_member2'@'localhost' IDENTIFIED BY 'NewPass@2026';

-- Grant full privileges to admin (project lead / developer)
GRANT ALL PRIVILEGES ON public_health_clinic.* TO 'clinic_admin'@'localhost';

-- Grant full privileges to group members working on the project
GRANT SELECT, INSERT, UPDATE, DELETE ON public_health_clinic.* TO 'emeric_walter'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON public_health_clinic.* TO 'group_member2'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON public_health_clinic.* TO 'group_member3'@'localhost';

-- Grant read-only access for reporting/viewing
GRANT SELECT ON public_health_clinic.* TO 'clinic_readonly'@'localhost';

-- Apply privilege changes
FLUSH PRIVILEGES;

-- View existing users (verify)
SELECT User, Host FROM mysql.user WHERE User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');

-- ============================================================
-- END OF SCRIPT
-- B3SEM1205F_GroupProject.sql
-- ============================================================
