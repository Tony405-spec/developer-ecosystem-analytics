-- DIAGNOSTIC QUERIES
-- Run these first to verify your data is loaded correctly

-- 1. Check row counts
SELECT 'company' AS table_name, COUNT(*) AS row_count FROM company
UNION ALL
SELECT 'tag_company', COUNT(*) FROM tag_company
UNION ALL
SELECT 'stackoverflow', COUNT(*) FROM stackoverflow
UNION ALL
SELECT 'tag_type', COUNT(*) FROM tag_type
UNION ALL
SELECT 'fortune500', COUNT(*) FROM fortune500
UNION ALL
SELECT 'ev311', COUNT(*) FROM ev311;

-- 2. Check date range of StackOverflow data
SELECT 
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    (MAX(date) - MIN(date)) AS date_span_days
FROM stackoverflow;

-- 3. Check for orphaned records (missing foreign keys)
SELECT 'tag_company without company' AS issue, COUNT(*) AS count
FROM tag_company tc
LEFT JOIN company c ON tc.company_id = c.id
WHERE c.id IS NULL
UNION ALL
SELECT 'stackoverflow without tag_company', COUNT(*)
FROM stackoverflow s
LEFT JOIN tag_company tc ON s.tag = tc.tag
WHERE tc.tag IS NULL;

-- 4. List all available technologies
SELECT DISTINCT tag, COUNT(*) AS records
FROM stackoverflow
GROUP BY tag
ORDER BY records DESC
LIMIT 20;

-- 5. Check data completeness by year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    COUNT(DISTINCT tag) AS unique_tags,
    SUM(question_count) AS total_questions
FROM stackoverflow
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year DESC;
