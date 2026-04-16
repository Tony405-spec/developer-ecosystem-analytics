-- Basic data diagnostics for developer-ecosystem-analytics.
-- Run before analytics to confirm referential integrity and data coverage.

-- 1) Row counts and date coverage for key tables.
SELECT 'stack_overflow_questions' AS table, COUNT(*) AS rows,
       MIN(created_at) AS min_ts, MAX(created_at) AS max_ts
FROM stack_overflow_questions
UNION ALL
SELECT 'stack_overflow_question_tags', COUNT(*), NULL, NULL FROM stack_overflow_question_tags
UNION ALL
SELECT 'developer_sentiment', COUNT(*), NULL, NULL FROM developer_sentiment
UNION ALL
SELECT 'companies', COUNT(*), NULL, NULL FROM companies
UNION ALL
SELECT 'company_tech_adoption', COUNT(*), NULL, NULL FROM company_tech_adoption
UNION ALL
SELECT 'company_question_mentions', COUNT(*), NULL, NULL FROM company_question_mentions;

-- 2) Null density for required columns.
SELECT
    'stack_overflow_questions' AS table,
    ROUND(AVG(CASE WHEN technology_id IS NULL THEN 1 ELSE 0 END)::numeric, 4) AS pct_null_technology_id,
    ROUND(AVG(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END)::numeric, 4) AS pct_null_created_at
FROM stack_overflow_questions;

SELECT
    'company_tech_adoption' AS table,
    ROUND(AVG(CASE WHEN adoption_score IS NULL THEN 1 ELSE 0 END)::numeric, 4) AS pct_null_adoption_score
FROM company_tech_adoption;

-- 3) Orphan detection for foreign keys.
SELECT COUNT(*) AS orphan_questions
FROM stack_overflow_questions q
LEFT JOIN technologies t ON t.technology_id = q.technology_id
WHERE t.technology_id IS NULL;

SELECT COUNT(*) AS orphan_adoption
FROM company_tech_adoption cta
LEFT JOIN companies c ON c.company_id = cta.company_id
WHERE c.company_id IS NULL;

-- 4) Duplicate checks for IDs.
SELECT question_id, COUNT(*) AS dupes
FROM stack_overflow_questions
GROUP BY question_id
HAVING COUNT(*) > 1;

SELECT technology_id, COUNT(*) AS dupes
FROM technologies
GROUP BY technology_id
HAVING COUNT(*) > 1;

-- 5) Coverage of survey sentiment vs. technologies.
SELECT
    COUNT(DISTINCT technology_id) AS technologies_with_sentiment,
    (SELECT COUNT(*) FROM technologies) AS technologies_total
FROM developer_sentiment;
