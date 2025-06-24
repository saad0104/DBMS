-- Active: 1748289247444@@127.0.0.1@3306@medical_db

DROP database IF EXISTS medical_db;
CREATE DATABASE medical_db;
USE medical_db;

CREATE TABLE drugs (
    drug_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_name VARCHAR(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS drug_categories (
    drug_category_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_category VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS drug_categorized_by (
    drug_id INT,
    drug_category_id INT,
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id),
    FOREIGN KEY (drug_category_id) REFERENCES drug_categories(drug_category_id),
    PRIMARY KEY (drug_id, drug_category_id)
);
CREATE TABLE side_effects (
    side_effect_id INT AUTO_INCREMENT PRIMARY KEY,
    side_effect_name VARCHAR(100) NOT NULL,
    unique(side_effect_name)
);

CREATE TABLE drug_side_effect (
    drug_id INT,
    side_effect_id INT,
    PRIMARY KEY (drug_id, side_effect_id),
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id),
    FOREIGN KEY (side_effect_id) REFERENCES side_effects(side_effect_id)
);

CREATE TABLE drug_interactions (
    interaction_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_id INT,
    interacts_with VARCHAR(100),
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id),
    UNIQUE (drug_id, interacts_with)
);


CREATE TABLE IF NOT EXISTS diseases (
    disease_id INT AUTO_INCREMENT PRIMARY KEY, 
    disease_name VARCHAR(255) NOT NULL, 
    disease_category VARCHAR(100)  
);

CREATE TABLE drug_disease (
    drug_id INT,
    disease_id INT,
    PRIMARY KEY (drug_id, disease_id),
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id),
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

CREATE TABLE IF NOT EXISTS clinical_trials (
    clinical_trial_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_id INT,
    clinical_trial_title VARCHAR(255),
    clinical_trial_count int,
    clinical_trial_start_date DATE,
    clinical_trial_completion_date DATE,
    clinical_trial_participants INT,
    clinical_trial_status VARCHAR(50),
    clinical_trial_condition VARCHAR(255),
    clinical_trial_main_researcher VARCHAR(100),
    FOREIGN KEY (drug_id) REFERENCES drugs (drug_id)  -- Foreign key to the drugs table
);

CREATE TABLE IF NOT EXISTS clinicalTrialLocation (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    clinical_trial_id INT,  -- Foreign key referencing clinical_trials
    clinical_trial_address VARCHAR(255) CHARACTER SET utf8,
    clinical_trial_institution VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    clinical_trial_address_1 VARCHAR(255) CHARACTER SET utf8,
    FOREIGN KEY (clinical_trial_id) REFERENCES clinical_trials(clinical_trial_id) ON DELETE CASCADE,  -- Links to clinical_trials
    UNIQUE (clinical_trial_institution, clinical_trial_address)  -- Ensures unique institution/address combo
);


create table product(
   prod_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_name VARCHAR(100) NOT NULL,
    company_name varchar(100) not null,
    drug_id INT,
    FOREIGN KEY (drug_id)
        REFERENCES drugs (drug_id),
    unique(prod_name)
);

INSERT INTO drugs (drug_name)
SELECT DISTINCT drug_name 
FROM drugData.sampleInformation
where drug_name is not null;
-- select * from drugs;

INSERT ignore INTO side_effects (side_effect_name)
SELECT DISTINCT side_effect
FROM drugData.sampleInformation
WHERE side_effect IS NOT NULL;

INSERT ignore INTO side_effects (side_effect_name)
SELECT DISTINCT side_effect_1
FROM drugData.sampleInformation
WHERE side_effect_1 IS NOT NULL;

INSERT ignore INTO side_effects (side_effect_name)
SELECT DISTINCT side_effect_2
FROM drugData.sampleInformation
WHERE side_effect_2 IS NOT NULL;

INSERT INTO side_effects (side_effect_name)
SELECT DISTINCT side_effect_3
FROM drugData.sampleInformation
WHERE side_effect_3 IS NOT NULL;

INSERT INTO side_effects (side_effect_name)
SELECT DISTINCT side_effect_4
FROM drugData.sampleInformation
WHERE side_effect_4 IS NOT NULL;

-- select * from side_effects;

INSERT IGNORE INTO drug_side_effect (drug_id, side_effect_id)
SELECT d.drug_id, se.side_effect_id
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
JOIN side_effects se ON si.side_effect = se.side_effect_name
WHERE si.side_effect IS NOT NULL;

INSERT IGNORE INTO drug_side_effect (drug_id, side_effect_id)
SELECT d.drug_id, se.side_effect_id
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
JOIN side_effects se ON si.side_effect_1 = se.side_effect_name
WHERE si.side_effect_1 IS NOT NULL;

INSERT IGNORE INTO drug_side_effect (drug_id, side_effect_id)
SELECT d.drug_id, se.side_effect_id
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
JOIN side_effects se ON si.side_effect_2 = se.side_effect_name
WHERE si.side_effect_2 IS NOT NULL;

INSERT IGNORE INTO drug_side_effect (drug_id, side_effect_id)
SELECT d.drug_id, se.side_effect_id
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
JOIN side_effects se ON si.side_effect_3 = se.side_effect_name
WHERE si.side_effect_3 IS NOT NULL;

INSERT IGNORE INTO drug_side_effect (drug_id, side_effect_id)
SELECT d.drug_id, se.side_effect_id
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
JOIN side_effects se ON si.side_effect_4 = se.side_effect_name
WHERE si.side_effect_4 IS NOT NULL;


INSERT INTO drug_categories (drug_category)
SELECT DISTINCT d.drug_category 
FROM drugdata.sampleinformation d
WHERE d.drug_category IS NOT NULL;

INSERT ignore INTO drug_categorized_by (drug_id, drug_category_id)
SELECT d.drug_id, dc.drug_category_id
FROM drugdata.sampleinformation di
JOIN drugs d ON di.drug_name = d.drug_name
JOIN drug_categories dc ON di.drug_category = dc.drug_category
WHERE di.drug_category IS NOT NULL;



INSERT IGNORE INTO drug_interactions (drug_id, interacts_with)
SELECT d.drug_id, si.interacts_with
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
WHERE si.interacts_with IS NOT NULL;

INSERT IGNORE INTO drug_interactions (drug_id, interacts_with)
SELECT d.drug_id, si.interacts_with_1
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
WHERE si.interacts_with_1 IS NOT NULL;

-- Insert drug interactions for the third column `interacts_with_2`
INSERT IGNORE INTO drug_interactions (drug_id, interacts_with)
SELECT d.drug_id, si.interacts_with_2
FROM drugData.sampleInformation si
JOIN drugs d ON si.drug_name = d.drug_name
WHERE si.interacts_with_2 IS NOT NULL;



INSERT INTO diseases (disease_name, disease_category)
SELECT DISTINCT disease_name, disease_category 
FROM drugData.sampleInformation
where disease_name is not null;


INSERT ignore INTO product (prod_name, company_name, drug_id)
SELECT product_name, company_name, drug_id
FROM drugData.sampleInformation
JOIN drugs ON sampleInformation.drug_name = drugs.drug_name;

INSERT ignore INTO clinical_trials (
    drug_id,
    clinical_trial_title,
    clinical_trial_count,
    clinical_trial_start_date,
    clinical_trial_completion_date,
    clinical_trial_participants,
    clinical_trial_status,
    clinical_trial_condition,

    clinical_trial_main_researcher
)
SELECT distinct 
    d.drug_id,  
   si.clinical_trial_title,
   COUNT(si.clinical_trial_title) OVER (PARTITION BY si.clinical_trial_title),
	si.clinical_trial_start_date,
    si.clinical_trial_completion_date, 
    si.clinical_trial_participants,     
    si.clinical_trial_status,           
    si.clinical_trial_condition,        
	si.clinical_trial_main_researcher  
FROM drugData.sampleInformation si
left JOIN drugs d ON si.drug_name = d.drug_name
WHERE si.clinical_trial_completion_date IS NOT NULL
;  


INSERT ignore INTO drug_disease (drug_id, disease_id)
SELECT 
    d.drug_id,  
    dis.disease_id  
FROM drugData.sampleInformation sd
JOIN drugs d ON sd.drug_name = d.drug_name 
JOIN diseases dis ON sd.disease_name = dis.disease_name;  


-- Example insert query for clinicalTrialLocation
INSERT ignore INTO clinicalTrialLocation (clinical_trial_id, clinical_trial_address, clinical_trial_institution, clinical_trial_address_1)
SELECT ct.clinical_trial_id, si.clinical_trial_address, si.clinical_trial_institution, si.clinical_trial_address_1
FROM drugData.sampleInformation si
JOIN clinical_trials ct ON si.clinical_trial_title = ct.clinical_trial_title  
WHERE si.clinical_trial_address IS NOT NULL;

