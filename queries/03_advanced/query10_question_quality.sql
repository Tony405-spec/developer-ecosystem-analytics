-- Question quality score per technology using acceptance, closure, and engagement signals.
WITH quality AS (
    SELECT
        technology_id,
        COUNT(*) AS questions,
        AVG(CASE WHEN is_answered THEN 1 ELSE 0 END) AS answer_rate,
        AVG(CASE WHEN closed_reason IS NOT NULL THEN 1 ELSE 0 END) AS closed_rate,
        AVG(score) AS avg_score,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY view_count) AS median_views,
        AVG(view_count) AS avg_views,
        AVG(answer_count) AS avg_answers
    FROM stack_overflow_questions
    GROUP BY technology_id
),
ranked AS (
    SELECT
        q.*,
        NTILE(100) OVER (ORDER BY COALESCE(q.answer_rate, 0)) AS p_answers,
        NTILE(100) OVER (ORDER BY COALESCE(1 - q.closed_rate, 0)) AS p_open,
        NTILE(100) OVER (ORDER BY COALESCE(q.avg_score, 0)) AS p_score,
        NTILE(100) OVER (ORDER BY COALESCE(q.median_views, 0)) AS p_views
    FROM quality q
)
SELECT
    tech.technology_name,
    tech.category,
    q.questions,
    q.answer_rate,
    q.closed_rate,
    q.avg_score,
    q.median_views,
    ROUND(
        (0.35 * p_answers + 0.25 * p_open + 0.25 * p_score + 0.15 * p_views) / 100.0,
        3
    ) AS question_quality_score
FROM ranked q
JOIN technologies tech ON tech.technology_id = q.technology_id
ORDER BY question_quality_score DESC NULLS LAST
LIMIT 25;
