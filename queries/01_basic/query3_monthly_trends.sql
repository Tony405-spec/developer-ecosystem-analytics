-- Monthly question trends by technology with rolling 3-month growth.
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', created_at) AS month,
        technology_id,
        COUNT(*) AS question_count,
        AVG(score) AS avg_score,
        AVG(answer_count) AS avg_answers,
        SUM(view_count) AS total_views
    FROM stack_overflow_questions
    GROUP BY 1, 2
),
with_growth AS (
    SELECT
        m.*,
        LAG(question_count, 3) OVER (PARTITION BY technology_id ORDER BY month) AS questions_3mo_ago
    FROM monthly m
),
scored AS (
    SELECT
        technology_id,
        month,
        question_count,
        avg_score,
        avg_answers,
        total_views,
        CASE
            WHEN questions_3mo_ago = 0 THEN NULL
            ELSE (question_count - questions_3mo_ago) / NULLIF(questions_3mo_ago::numeric, 0)
        END AS growth_vs_prior_3mo
    FROM with_growth
)
SELECT
    tech.technology_name,
    tech.category,
    s.month,
    s.question_count,
    s.growth_vs_prior_3mo,
    s.avg_answers,
    s.avg_score,
    s.total_views
FROM scored s
JOIN technologies tech ON tech.technology_id = s.technology_id
ORDER BY tech.technology_name, s.month;
