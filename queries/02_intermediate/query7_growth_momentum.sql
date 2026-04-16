-- Growth momentum score comparing recent activity vs trailing baseline.
WITH bounds AS (
    SELECT
        current_date - INTERVAL '30 days' AS recent_start,
        current_date - INTERVAL '180 days' AS baseline_start
),
activity AS (
    SELECT
        q.technology_id,
        COUNT(*) FILTER (WHERE q.created_at >= b.recent_start) AS questions_30d,
        COUNT(*) FILTER (
            WHERE q.created_at < b.recent_start
              AND q.created_at >= b.baseline_start
        ) AS questions_prev_150d,
        SUM(q.view_count) FILTER (WHERE q.created_at >= b.recent_start) AS views_30d,
        AVG(q.score) FILTER (WHERE q.created_at >= b.recent_start) AS avg_score_30d
    FROM stack_overflow_questions q
    CROSS JOIN bounds b
    GROUP BY q.technology_id, b.recent_start, b.baseline_start
),
adoption AS (
    SELECT
        technology_id,
        AVG(adoption_score) AS avg_adoption_score
    FROM company_tech_adoption
    GROUP BY technology_id
),
momentum AS (
    SELECT
        tech.technology_id,
        tech.technology_name,
        tech.category,
        a.questions_30d,
        a.views_30d,
        a.avg_score_30d,
        a.questions_prev_150d,
        CASE
            WHEN a.questions_prev_150d = 0 THEN NULL
            ELSE (a.questions_30d * 5.0 - a.questions_prev_150d) / NULLIF(a.questions_prev_150d::numeric, 0)
        END AS velocity_ratio,
        adopt.avg_adoption_score
    FROM technologies tech
    LEFT JOIN activity a ON a.technology_id = tech.technology_id
    LEFT JOIN adoption adopt ON adopt.technology_id = tech.technology_id
),
ranked AS (
    SELECT
        m.*,
        NTILE(100) OVER (ORDER BY COALESCE(m.velocity_ratio, 0)) AS p_velocity,
        NTILE(100) OVER (ORDER BY COALESCE(m.questions_30d, 0)) AS p_volume,
        NTILE(100) OVER (ORDER BY COALESCE(m.avg_score_30d, 0)) AS p_quality,
        NTILE(100) OVER (ORDER BY COALESCE(m.avg_adoption_score, 0)) AS p_adoption
    FROM momentum m
)
SELECT
    technology_name,
    category,
    questions_30d,
    velocity_ratio,
    avg_score_30d,
    avg_adoption_score,
    ROUND(
        (0.35 * p_velocity + 0.30 * p_volume + 0.20 * p_quality + 0.15 * p_adoption) / 100.0,
        3
    ) AS growth_momentum_score
FROM ranked
ORDER BY growth_momentum_score DESC NULLS LAST
LIMIT 25;
