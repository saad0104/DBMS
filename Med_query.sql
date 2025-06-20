-- ### a. Find the number of drugs that have nausea as a side efect

SELECT COUNT(d.drug_id) 
FROM drugs d
JOIN drug_side_effect dse ON d.drug_id = dse.drug_id
JOIN side_effects se ON dse.side_effect_id = se.side_effect_id
WHERE se.side_effect_name = 'nausea';

-- Ans = 2.

-- ### b. Find the drugs that interact with butabarbital

SELECT DISTINCT d.drug_name 
FROM drugs d
JOIN drug_interactions di ON d.drug_id = di.drug_id
WHERE di.interacts_with = 'butabarbital';

-- Ans = hydrocortisone

-- ### c. Find the drugs with side eects cough and headache

SELECT DISTINCT d.drug_name
FROM drugs d
JOIN drug_side_effect dse ON d.drug_id = dse.drug_id
JOIN side_effects se ON dse.side_effect_id = se.side_effect_id
WHERE se.side_effect_name = 'cough' OR se.side_effect_name = 'headache';

-- Ans = cetuximab , denileukin diftitox


-- ### d. Find the drugs that can be used to treat endocrine diseases

SELECT DISTINCT d.drug_name
FROM drugs d
JOIN drug_disease dd ON d.drug_id = dd.drug_id
JOIN diseases dss ON dd.disease_id = dss.disease_id
WHERE dss.disease_category = 'Endocrine';

-- Ans = hydrocortisone


-- ### e. Find the most common treatment for immunological diseases that have not been used for
-- hematological diseases

SELECT DISTINCT d.drug_name
FROM drugs d
JOIN drug_disease dd ON d.drug_id = dd.drug_id
JOIN diseases dss ON dd.disease_id = dss.disease_id
WHERE dss.disease_category = 'Immunological' AND d.drug_name NOT IN(
    SELECT DISTINCT d2.drug_name
FROM drugs d2
JOIN drug_disease dd2 ON d2.drug_id = dd2.drug_id
JOIN diseases dss2 ON dd2.disease_id = dss2.disease_id
WHERE dss2.disease_category = 'Hematological'
);

-- Ans = denileukin diftitox, hydrocortisone


-- ### f. Find the diseases that can be treated with hydrocortisone but not with etanercept

SELECT DISTINCT dss.disease_name
FROM diseases dss
JOIN drug_disease dd ON dss.disease_id = dd.disease_id
JOIN drugs d ON dd.drug_id = d.drug_id
WHERE d.drug_name = 'hydrocortisone' AND dss.disease_id NOT IN(
    SELECT DISTINCT dss2.disease_id 
    FROM diseases dss2
    JOIN drug_disease dd2 ON dss2.disease_id = dd2.disease_id
    JOIN drugs d2 ON dd2.drug_id = d2.drug_id
    WHERE d2.drug_name = 'etanercept'
);

-- Ans = Atherosclerosis, Cortisol resistance, Obesity, Asthma, dimished response to antileukotriene treatment in, 600807, 
-- Atherosclerosis, susceptibility to, Malaria, resistance to, 248310, Obesity, adrenal insufficiency, and red hair.

-- ### g. Find the top-10 side effects that drugs used to treat asthma related diseases have


SELECT side_effect_name AS 'Side_Effect', COUNT(se.side_effect_name) AS 'Freqency' 
FROM diseases dss 
JOIN drug_disease dd ON dss.disease_id = dss.disease_id
JOIN drug_side_effect dse ON dd.drug_id = dse.drug_id
JOIN side_effects se ON dse.side_effect_id = se.side_effect_id
WHERE dss.disease_name LIKE '%Asthma%'
GROUP BY se.side_effect_name
LIMIT 10;

-- Ans = Side_Effect  | Frequency
    --vasodilatation  | 135
    --somnolence      | 459
    --renal failure   | 459
    -- pain           | 135
    -- nausea         | 837
    -- melanoma       | 675
    -- headache       | 594
    -- fever          | 162
    -- diziness       | 810
    -- dehydration    | 135

-- ### h. Find the drugs that have been studied in more than three clinical trials with more than 30
-- participants

SELECT d.drug_name AS 'Drug_Name', COUNT(DISTINCT ct.clinical_trial_id) AS 'Trials'
FROM drugs d
JOIN clinical_trials ct ON d.drug_id = ct.drug_id
 WHERE clinical_trial_count > 3 AND
 clinical_trial_participants > 30
 GROUP BY drug_name;

-- Ans = Drug_Name | Trials
        -- abciximab | 5
        -- cetuximab | 5
        -- hydrocortisone | 5

-- ### i. Find the largest number of clinical trials and the drugs they have studied that have been
-- active in the same period of time


SELECT d.drug_name
FROM drugs d
JOIN clinical_trials ct ON d.drug_id = ct.drug_id
WHERE ct.clinical_trial_count = (
    SELECT MAX(clinical_trial_count) FROM clinical_trials
)
GROUP BY d.drug_name;

-- Ans = hydrocortisone


-- ### j. Find the main researchers that have conducted clinical trials that study drugs that can be
-- used to treat both respiratory and cardiovascular diseases

SELECT DISTINCT ct.clinical_trial_main_researcher
FROM clinical_trials ct
JOIN drug_disease dd ON ct.drug_id = dd.drug_id
JOIN diseases ds ON dd.disease_id = ds.disease_id
WHERE ds.disease_category = 'respiratory' 
AND ct.clinical_trial_id IN
(
    SELECT DISTINCT ct2.clinical_trial_id
FROM clinical_trials ct2
JOIN drug_disease dd2 ON ct2.drug_id = dd2.drug_id
JOIN diseases ds2 ON dd2.disease_id = ds2.disease_id
WHERE ds2.disease_category = 'cardiovascular'
);

-- Ans = Djillali Annane, Boni Elewski, MD


-- k. Find up to three main researchers that have conductd the larger number of clinical trials
-- that study drugs that can be used to treat both respiratory and cardiovascular diseases

SELECT ct.clinical_trial_main_researcher, COUNT(DISTINCT ct.clinical_trial_id ) AS 'T_Count'
FROM diseases dis
JOIN drug_disease dd ON dd.disease_id = dis.disease_id
JOIN clinical_trials ct ON ct.drug_id = dd.drug_id
WHERE ct.drug_id IN (
    SELECT d.drug_id
    FROM diseases ds
    JOIN drug_disease d ON d.disease_id = ds.disease_id
    WHERE ds.disease_category = 'Respiratory'
) AND ct.drug_id IN (
    SELECT d.drug_id
    FROM diseases ds
    JOIN drug_disease d ON d.disease_id = ds.disease_id
    WHERE ds.disease_category = 'Cardiovascular'
)
GROUP BY ct.clinical_trial_main_researcher
ORDER BY T_Count DESC
LIMIT 3;

-- Ans = Djillali Annane, Boni Elewski, MD


-- l. Find the categories of drugs that have been only studied in clinical trials based in United
-- States

SELECT DISTINCT drug_category 
FROM drug_categories dc
JOIN drug_categorized_by dcb ON dcb.drug_category_id = dc.drug_category_id
JOIN clinical_trials ct ON ct.drug_id = dcb.drug_id
JOIN clinicaltriallocation ctl ON ctl.clinical_trial_id = ct.clinical_trial_id
WHERE ctl.clinical_trial_address = 'United States';

-- Ans = Antirheumatic agents, Immunomodulatory agents.
