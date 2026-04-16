-- Identify technologies at risk of decline based on multiple factors
WITH tech_health AS (
    SELECT 
        tag,
        SUM(question_count) AS total_questions,
        ROUND(AVG(unanswered_pct)::numeric, 2) AS avg_difficulty,
        COUNT(DISTINCT date) AS active_days,
        MAX(date) AS last_activity,
        ROUND((SUM(question_count) * (1 - AVG(unanswered_pct) / 100))::numeric, 2) AS health_score
    FROM stackoverflow
    GROUP BY tag
    HAVING SUM(question_count) > 500
)
SELECT 
    tag,
    total_questions,
    avg_difficulty         AS difficulty_pct,
    active_days,
    last_activity,
    health_score,
    CASE 
        WHEN last_activity < CURRENT_DATE - INTERVAL '90 days' THEN 'CRITICAL - No recent activity'
        WHEN avg_difficulty > 40                                THEN 'HIGH - Too difficult'
        WHEN health_score < 1000                               THEN 'MEDIUM - Low engagement'
        ELSE 'HEALTHY'
    END AS risk_status
FROM tech_health
ORDER BY 
    CASE 
        WHEN last_activity < CURRENT_DATE - INTERVAL '90 days' THEN 1
        WHEN avg_difficulty > 40                                THEN 2
        WHEN health_score < 1000                               THEN 3
        ELSE 4
    END,
    health_score ASC
LIMIT 20;
