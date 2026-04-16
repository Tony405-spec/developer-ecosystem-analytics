-- For each company, find their hardest technology
WITH company_tech_difficulty AS (
    SELECT 
        c.name AS company_name,
        tc.tag,
        SUM(s.question_count) AS total_questions,
        (100.0 * SUM(s.unanswered_count) / NULLIF(SUM(s.question_count), 0))::numeric(10,2) AS unanswered_pct
    FROM company c
    JOIN tag_company tc ON c.id = tc.company_id
    JOIN stackoverflow s ON tc.tag = s.tag
    GROUP BY c.name, tc.tag
    HAVING SUM(s.question_count) >= 50
),
ranked_difficulty AS (
    SELECT 
        company_name,
        tag,
        unanswered_pct,
        ROW_NUMBER() OVER (PARTITION BY company_name ORDER BY unanswered_pct DESC) AS difficulty_rank
    FROM company_tech_difficulty
)
SELECT 
    company_name,
    tag AS hardest_technology,
    unanswered_pct AS unanswered_percentage
FROM ranked_difficulty
WHERE difficulty_rank = 1
ORDER BY unanswered_pct DESC
LIMIT 15;
