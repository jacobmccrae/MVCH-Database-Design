CREATE TABLE STAFF
(Staff_ID NUMBER(5), 
F_name VARCHAR2(30) NOT NULL,
L_name VARCHAR2(30) NOT NULL,
M VARCHAR2(1),
SSN NUMBER(20) NOT NULL UNIQUE, 
Sex VARCHAR2(1), 
Salary NUMBER(20) NOT NULL,
DOB DATE NOT NULL,
Position VARCHAR2(20),
CONSTRAINT STAFF_Staff_ID_pk PRIMARY KEY (Staff_ID));

CREATE TABLE STAFF_CONTACT_INFO
(Staff_ID NUMBER(5),
House_Num VARCHAR2(10),
Street_Name VARCHAR2(30),
City VARCHAR2(20) NOT NULL,
Province VARCHAR2(3) NOT NULL,
Postal_Code CHAR(6) NOT NULL, 
Phone NUMBER(10) NOT NULL,
CONSTRAINT STAFF_CONTACT_INFO_Staff_ID_pk PRIMARY KEY (Staff_ID, House_Num, Street_Name),
CONSTRAINT STAFF_CONTACT_INFO_Staff_ID_fk FOREIGN KEY (Staff_ID) REFERENCES STAFF(Staff_ID));

CREATE TABLE MEDICAL_STAFF
(Med_ID NUMBER(5),
Staff_ID NUMBER (5),
CONSTRAINT MEDICAL_STAFF_Med_ID_pk PRIMARY KEY (Med_ID),
CONSTRAINT MEDICAL_STAFF_Staff_ID_fk FOREIGN KEY (Staff_ID) REFERENCES STAFF(Staff_ID));

CREATE TABLE FACILITY
(Facility_No NUMBER(5),
Name VARCHAR2(30) NOT NULL,
Matron_ID NUMBER(5),
CONSTRAINT FACILITY_Facility_No_pk PRIMARY KEY (Facility_No),
CONSTRAINT FACILITY_Matron_ID_fk FOREIGN KEY (Matron_ID) REFERENCES MEDICAL_STAFF(Med_ID));

CREATE TABLE DIAGNOSTICS_UNIT
(Unit_ID NUMBER(5),
Name VARCHAR2(30) NOT NULL,
Facility_No NUMBER(5),
CONSTRAINT DIAGNOSTICS_UNIT_Unit_ID_pk PRIMARY KEY (Unit_ID),
CONSTRAINT DIAGNOSTICS_UNIT_Fac_No_fk FOREIGN KEY (Facility_No) REFERENCES FACILITY(Facility_No));

CREATE TABLE WARD
(Ward_No NUMBER(5),
No_Staff NUMBER(5),
Name VARCHAR2(30) NOT NULL,
Facility_No NUMBER(5),
CONSTRAINT WARD_Ward_No_pk PRIMARY KEY (Ward_No),
CONSTRAINT WARD_Facility_No_fk FOREIGN KEY (Facility_No) REFERENCES FACILITY(Facility_No));

CREATE TABLE BED
(Bed_ID NUMBER(5),
Room_No NUMBER(5),
Bed_No NUMBER(5),
Occupied CHAR(1),
Ward_No NUMBER(5),
Cleaned CHAR(1),
CONSTRAINT BED_Bed_ID_pk PRIMARY KEY (Bed_ID),
CONSTRAINT BED_Ward_No_fk FOREIGN KEY (Ward_No) REFERENCES WARD(Ward_No),
CONSTRAINT BED_Occupied_cc CHECK (Occupied='Y' or Occupied='N'),
CONSTRAINT BED_Cleaned_cc CHECK(Cleaned='Y' or Cleaned='N'));

CREATE TABLE PHYSICIAN
(P_ID NUMBER(5),
Specialty VARCHAR2(30) NOT NULL,
Med_ID NUMBER(5),
CONSTRAINT PHYSICIAN_P_ID_pk PRIMARY KEY (P_ID),
CONSTRAINT PHYSICIAN_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES MEDICAL_STAFF(Med_ID));

CREATE TABLE NURSE
(Nurse_ID NUMBER(5),
Matron CHAR(1) NOT NULL,
Ward_No NUMBER(5),
Med_ID NUMBER(5),
CONSTRAINT NURSE_Nurse_ID_pk PRIMARY KEY (Nurse_ID),
CONSTRAINT NURSE_Ward_No_fk FOREIGN KEY (Ward_No) REFERENCES WARD(Ward_No),
CONSTRAINT NURSE_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES MEDICAL_STAFF(Med_ID),
CONSTRAINT NURSE_Matron_chk CHECK(Matron='Y' OR Matron='N'));

CREATE TABLE ADMINISTRATION
(Admin_ID NUMBER(5),
Staff_ID NUMBER(5),
CONSTRAINT ADMINISTRATION_Admin_ID_pk PRIMARY KEY (Admin_ID),
CONSTRAINT ADMINISTRATION_Staff_ID_fk FOREIGN KEY (Staff_ID) REFERENCES STAFF(Staff_ID));

CREATE TABLE WORKS_IN
(Staff_ID NUMBER(5),
Facility_No NUMBER(5),
Date_Time_In DATE,
Date_Time_Out DATE,
Oncall CHAR(1),
CONSTRAINT WORKS_IN_Staff_ID_pk PRIMARY KEY (Staff_ID, Facility_No),
CONSTRAINT WORKS_IN_Staff_ID_fk FOREIGN KEY (Staff_ID) REFERENCES STAFF(Staff_ID),
CONSTRAINT WORKS_IN_Facility_No_fk FOREIGN KEY (Facility_No) REFERENCES FACILITY(Facility_No),
CONSTRAINT WORKS_IN_Oncall_CC CHECK(Oncall='Y' OR Oncall='N'));

CREATE TABLE PATIENT
(Health_ID NUMBER(10), 
L_name VARCHAR2(30) NOT NULL,
F_name VARCHAR2(30) NOT NULL,
M VARCHAR2(1),
Sex VARCHAR2(1) NOT NULL,
Weight VARCHAR2(5) NOT NULL,
Height VARCHAR2(5) NOT NULL,
DOB DATE NOT NULL,
CONSTRAINT PATIENT_Health_ID_pk PRIMARY KEY (Health_ID));

CREATE TABLE PATIENT_CONTACT
(Health_ID NUMBER(10), 
House_Num VARCHAR2(10),
Street_Name VARCHAR2(30),
City VARCHAR2(30) NOT NULL,
Province VARCHAR2(3) NOT NULL,
Postal_Code CHAR(6) NOT NULL,
Phone NUMBER(10) NOT NULL,
CONSTRAINT PATIENT_CONTACT_Health_ID_pk PRIMARY KEY (Health_ID, House_Num, Street_Name),
CONSTRAINT PATIENT_CONTACT_Health_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT(Health_ID));

CREATE TABLE PATIENT_STATUS
(Status VARCHAR2(10),
Health_ID NUMBER(10),
Date_Time_IN DATE,
Date_Time_OUT DATE,
Scheduled_Time DATE,
Reason VARCHAR2(50),
Med_ID NUMBER(5),
Bed_ID NUMBER(5),
Ward_No NUMBER(5) NOT NULL,
CONSTRAINT PATIENT_STATUS_Status_pk PRIMARY KEY (Status, Health_ID, Date_Time_IN),
CONSTRAINT PATIENT_STATUS_Health_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT (Health_ID),
CONSTRAINT PATIENT_STATUS_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES MEDICAL_STAFF (Med_ID),
CONSTRAINT PATIENT_STATUS_Bed_ID_fk FOREIGN KEY (Bed_ID) REFERENCES BED(Bed_ID),
CONSTRAINT PATIENT_STATUS_Ward_No_fk FOREIGN KEY (Ward_No) REFERENCES WARD(Ward_No),
CONSTRAINT PATIENT_STATUS_Status_cc CHECK (Status = 'IN' OR Status = 'OUT' OR Status = 'EMERGENCY' OR Status = 'DISCHARGED' OR Status='TRANSFER'));
 
CREATE TABLE VITALS
(Health_ID NUMBER(10),
Date_Time DATE,
Nurse_ID NUMBER(5),
Heart_Rate VARCHAR2(5),
Temperature VARCHAR2(5),
Blood_Pressure VARCHAR2(8),
Respiration_Rate VARCHAR2(5),
Comments VARCHAR2(50),
CONSTRAINT VITALS_Health_ID_Date_Time_pk PRIMARY KEY (Health_ID, Date_Time),
CONSTRAINT VITALS_Health_ID_fk FOREIGN KEY(Health_ID) REFERENCES PATIENT(Health_ID),
CONSTRAINT VITALS_Nurse_ID_fk FOREIGN KEY(Nurse_ID) REFERENCES NURSE(Nurse_ID));

CREATE TABLE PATIENT_ALLERGY
(Health_ID NUMBER(10),
Allergy_Name VARCHAR2(30),
Allergy_Description VARCHAR2(50),
CONSTRAINT PATIENT_ALLERGY_Health_ID_pk PRIMARY KEY (Health_ID, Allergy_Name),
CONSTRAINT PATIENT_ALLERGY_Health_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT (HEALTH_ID));

CREATE TABLE PATIENT_MEDICATION
(Health_ID NUMBER(10),
Med_Name VARCHAR2(30),
Med_Dosage NUMBER(5),
Med_Description VARCHAR2(50),
CONSTRAINT PATIENT_MEDICATION_H_ID_pk PRIMARY KEY (Health_ID, Med_Name),
CONSTRAINT PATIENT_MEDICATION_H_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT (Health_ID));

CREATE TABLE BILLING_INFO
(Bill_ID NUMBER(5),
Amount NUMBER(10),
Bill_Date DATE,
Health_ID NUMBER(10),
Admin_ID NUMBER(5),
Paid CHAR(1),
CONSTRAINT BILLING_INFO_B_ID_pk PRIMARY KEY (Bill_ID),
CONSTRAINT BILLING_INFO_H_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT(Health_ID),
CONSTRAINT BILLING_INFO_A_ID_fk FOREIGN KEY (Admin_ID) REFERENCES ADMINISTRATION(Admin_ID),
CONSTRAINT BILLING_INFO_Paid_CC CHECK(Paid='Y' OR Paid='N'));

CREATE TABLE EMERGENCY_CONTACT
(Health_ID NUMBER(10),
Name VARCHAR2(30),
Phone NUMBER(10),
Address VARCHAR2(30),
CONSTRAINT EMERGENCY_CONTACT_H_ID_pk PRIMARY KEY (Health_ID, Name),
CONSTRAINT EMERGENCY_CONTACT_H_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT(Health_ID));

CREATE TABLE ORDERS
(Order_ID NUMBER(5),
Order_Details VARCHAR2(50) NOT NULL,
Health_ID NUMBER(10),
Date_Time_Ordered DATE,
Date_Time_Treated DATE,
Med_ID NUMBER(5),
P_ID NUMBER(5),
Unit_ID NUMBER(5),
Results VARCHAR(30), 
CONSTRAINT ORDERS_Order_ID_Health_ID_pk PRIMARY KEY (Order_ID, Health_ID),
CONSTRAINT ORDERS_Health_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT(Health_ID),
CONSTRAINT ORDERS_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES MEDICAL_STAFF (Med_ID),
CONSTRAINT ORDERS_P_ID_fk FOREIGN KEY (P_ID) REFERENCES PHYSICIAN (P_ID),
CONSTRAINT ORDERS_Unit_ID_fk FOREIGN KEY(Unit_ID) REFERENCES DIAGNOSTICS_UNIT(Unit_ID));

CREATE TABLE DIAGNOSIS
(Diagnosis_ID NUMBER(5),
P_ID NUMBER(5),
Health_ID NUMBER(10),
Diagnosis_Name VARCHAR2(50),
CONSTRAINT DIAGNOSIS_Diagnosis_ID_pk PRIMARY KEY (Diagnosis_ID, P_ID, Health_ID),
CONSTRAINT DIAGNOSIS_P_ID_fk FOREIGN KEY (P_ID) REFERENCES PHYSICIAN(P_ID),
CONSTRAINT DIAGNOSIS_Health_ID_fk FOREIGN KEY (Health_ID) REFERENCES PATIENT(Health_ID));

CREATE TABLE VENDOR
(Vend_ID NUMBER(5),
Address VARCHAR2(50),
Company_Name VARCHAR2(30) NOT NULL,
CONSTRAINT VENDOR_Vend_ID_pk PRIMARY KEY (Vend_ID));

CREATE TABLE ITEM
(Item_ID NUMBER(5),
Cost NUMBER(5),
Vend_ID NUMBER(5),
CONSTRAINT ITEM_Item_ID_pk PRIMARY KEY (Item_ID),
CONSTRAINT ITEM_Vend_ID_fk FOREIGN KEY (Vend_ID) REFERENCES VENDOR(Vend_ID));

CREATE TABLE ITEM_USED
(Staff_ID NUMBER(5),
Item_ID NUMBER(5),
Date_Used DATE,
Quantity NUMBER(5),
CONSTRAINT ITEM_USED_Staff_ID_pk PRIMARY KEY (Staff_ID, Item_ID, Date_Used),
CONSTRAINT ITEM_USED_Staff_ID_fk FOREIGN KEY (Staff_ID) REFERENCES STAFF(Staff_ID),
CONSTRAINT ITEM_USED_Item_ID_fk FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID));

CREATE TABLE ITEM_TYPE
(Item_ID NUMBER(5),
Item_Name VARCHAR2(30),
Item_Type VARCHAR2(30),
CONSTRAINT ITEM_TYPE_Item_ID_Item_Type_pk PRIMARY KEY (Item_ID, Item_Type),
CONSTRAINT ITEM_TYPE_Item_ID_fk FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID));

CREATE TABLE SUPPLY
(Item_ID NUMBER(5),
Date_Purchased DATE,
Date_Expected DATE,
Quantity NUMBER(5), 
Admin_ID NUMBER(5),
CONSTRAINT SUPPLY_Item_ID_pk PRIMARY KEY (Item_ID, Date_Purchased),
CONSTRAINT SUPPLY_Item_ID_fk FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID),
CONSTRAINT SUPPLY_Admin_ID_fk FOREIGN KEY (Admin_ID) REFERENCES ADMINISTRATION(Admin_ID));