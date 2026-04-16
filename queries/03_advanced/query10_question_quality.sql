-- Analyze the relationship between question volume and answer quality
SELECT 
    tag,
    SUM(question_count) AS total_questions,
    (AVG(question_pct))::numeric(10,2) AS avg_question_share,
    (AVG(unanswered_pct))::numeric(10,2) AS avg_unanswered_rate,
    (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0))::numeric(10,2) AS overall_unanswered_rate,
    CASE 
        WHEN SUM(question_count) > 10000 AND (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0)) < 20 THEN 'High Volume, High Quality'
        WHEN SUM(question_count) > 10000 AND (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0)) > 30 THEN 'High Volume, Poor Quality'
        WHEN SUM(question_count) < 1000 AND (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0)) < 20 THEN 'Low Volume, High Quality'
        WHEN SUM(question_count) < 1000 AND (100.0 * SUM(unanswered_count) / NULLIF(SUM(question_count), 0)) > 30 THEN 'Low Volume, Poor Quality'
        ELSE 'Average'
    END AS quality_category
FROM stackoverflow
GROUP BY tag
HAVING SUM(question_count) >= 500
ORDER BY total_questions DESC
LIMIT 20;
