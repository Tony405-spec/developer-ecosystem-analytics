-- Hardest technologies based on unanswered question percentage
SELECT 
    tag,
    SUM(question_count) AS total_questions,
    SUM(unanswered_count) AS unanswered_count,
    (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0))::numeric(10,2) AS unanswered_percentage
FROM stackoverflow
GROUP BY tag
HAVING SUM(question_count) >= 100
ORDER BY unanswered_percentage DESC
LIMIT 10;
