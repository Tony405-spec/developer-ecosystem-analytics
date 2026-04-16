-- Compare difficulty across different technology types
SELECT 
    tt.type AS technology_category,
    COUNT(DISTINCT tt.tag) AS num_technologies,
    SUM(s.question_count) AS total_questions,
    (AVG(s.unanswered_pct))::numeric(10,2) AS avg_unanswered_pct,
    (STDDEV(s.unanswered_pct))::numeric(10,2) AS difficulty_variance
FROM tag_type tt
JOIN stackoverflow s ON tt.tag = s.tag
GROUP BY tt.type
ORDER BY total_questions DESC;
