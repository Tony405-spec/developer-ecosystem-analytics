-- Calculate technology diversity score for each company
SELECT 
    c.name AS company_name,
    COUNT(DISTINCT tc.tag) AS num_technologies,
    COUNT(DISTINCT tt.type) AS num_tech_categories,
    SUM(s.question_count) AS total_developer_questions,
    ROUND((SUM(s.question_count) * 1.0 / NULLIF(COUNT(DISTINCT tc.tag), 0))::numeric, 2) AS avg_questions_per_tech,
    CASE 
        WHEN COUNT(DISTINCT tt.type) >= 3 THEN 'High Diversity'
        WHEN COUNT(DISTINCT tt.type) >= 2 THEN 'Medium Diversity'
        ELSE 'Low Diversity'
    END AS diversity_rating
FROM company c
JOIN tag_company tc ON c.id = tc.company_id
LEFT JOIN tag_type tt ON tc.tag = tt.tag
LEFT JOIN stackoverflow s ON tc.tag = s.tag
GROUP BY c.id, c.name
ORDER BY total_developer_questions DESC
LIMIT 10;
