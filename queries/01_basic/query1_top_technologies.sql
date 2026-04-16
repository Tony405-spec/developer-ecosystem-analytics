-- Find which technologies generate the most developer questions
SELECT 
    tag,
    SUM(question_count) AS total_questions,
    SUM(unanswered_count) AS total_unanswered,
    (AVG(unanswered_pct))::numeric(10,2) AS avg_unanswered_pct,
    COUNT(DISTINCT date) AS days_with_activity
FROM stackoverflow
GROUP BY tag
ORDER BY total_questions DESC
LIMIT 10;
