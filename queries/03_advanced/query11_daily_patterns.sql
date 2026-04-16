-- Analyze which days of week have highest developer activity
SELECT 
    EXTRACT(DOW FROM date) AS day_of_week,
    CASE EXTRACT(DOW FROM date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_name,
    AVG(question_count) AS avg_daily_questions,
    SUM(question_count) AS total_questions,
    (AVG(unanswered_pct))::numeric(10,2) AS avg_unanswered_pct
FROM stackoverflow
GROUP BY EXTRACT(DOW FROM date)
ORDER BY avg_daily_questions DESC;
