-- First, find what tags actually exist in your data
-- Then run this with actual tags from your data

-- Version 1: Show top 5 tags by total questions first
SELECT 
    tag,
    SUM(question_count) AS total_questions
FROM stackoverflow
GROUP BY tag
ORDER BY total_questions DESC
LIMIT 5;

-- Version 2: Then use those actual tags (replace 'python' with real tags from above)
SELECT 
    tag,
    DATE_TRUNC('month', date) AS month,
    SUM(question_count) AS monthly_questions,
    SUM(unanswered_count) AS monthly_unanswered,
    (AVG(unanswered_pct))::numeric(10,2) AS avg_unanswered_pct
FROM stackoverflow
WHERE tag IN ('javascript', 'python', 'java', 'c#', 'php')  -- Use tags from your data
GROUP BY tag, DATE_TRUNC('month', date)
ORDER BY tag, month DESC;

-- Version 3: Show all tags that have any data
SELECT 
    tag,
    DATE_TRUNC('month', date) AS month,
    SUM(question_count) AS monthly_questions
FROM stackoverflow
GROUP BY tag, DATE_TRUNC('month', date)
ORDER BY month DESC, monthly_questions DESC
LIMIT 50;
