-- Top technologies by recent community momentum and sentiment.
-- Metrics blend Stack Overflow velocity, growth vs. prior quarter, company adoption, and survey satisfaction.
WITH time_bounds AS (
    SELECT
        current_date - INTERVAL '90 days' AS window_start,
        current_date - INTERVAL '180 days' AS prior_start
),
recent AS (
    SELECT
        q.technology_id,
        COUNT(*) FILTER (WHERE q.created_at >= t.window_start) AS questions_last_90d,
        COUNT(*) FILTER (
            WHERE q.created_at < t.window_start
              AND q.created_at >= t.prior_start
        ) AS questions_prev_90d,
        AVG(q.score) FILTER (WHERE q.created_at >= t.window_start) AS avg_score_last_90d,
        AVG(q.answer_count) FILTER (WHERE q.created_at >= t.window_start) AS avg_answers_last_90d,
        SUM(q.view_count) FILTER (WHERE q.created_at >= t.window_start) AS views_last_90d
    FROM stack_overflow_questions q
    CROSS JOIN time_bounds t
    GROUP BY q.technology_id, t.window_start, t.prior_start
),
adoption AS (
    SELECT
        technology_id,
        COUNT(*) FILTER (WHERE adoption_level IN ('adopted', 'strategic')) AS strategic_accounts,
        AVG(adoption_score) AS avg_adoption_score
    FROM company_tech_adoption
    GROUP BY technology_id
),
sentiment AS (
    SELECT DISTINCT ON (technology_id)
        technology_id,
        survey_year,
        satisfaction_score,
        adoption_score AS survey_adoption_score,
        learning_curve
    FROM developer_sentiment
    ORDER BY technology_id, survey_year DESC
),
scored AS (
    SELECT
        tech.technology_id,
        tech.technology_name,
        tech.category,
        r.questions_last_90d,
        r.questions_prev_90d,
        r.avg_score_last_90d,
        r.avg_answers_last_90d,
        r.views_last_90d,
        a.strategic_accounts,
        a.avg_adoption_score,
        s.satisfaction_score,
        s.survey_adoption_score,
        s.learning_curve,
        CASE
            WHEN r.questions_prev_90d = 0 THEN 1.0
            ELSE (r.questions_last_90d - r.questions_prev_90d) / NULLIF(r.questions_prev_90d::numeric, 0)
        END AS question_growth_rate
    FROM technologies tech
    LEFT JOIN recent r ON r.technology_id = tech.technology_id
    LEFT JOIN adoption a ON a.technology_id = tech.technology_id
    LEFT JOIN sentiment s ON s.technology_id = tech.technology_id
),
normalized AS (
    SELECT
        s.*,
        NTILE(100) OVER (ORDER BY questions_last_90d) AS p_questions,
        NTILE(100) OVER (ORDER BY question_growth_rate) AS p_growth,
        NTILE(100) OVER (ORDER BY COALESCE(avg_score_last_90d, 0)) AS p_quality,
        NTILE(100) OVER (ORDER BY COALESCE(avg_answers_last_90d, 0)) AS p_engagement,
        NTILE(100) OVER (ORDER BY COALESCE(avg_adoption_score, 0)) AS p_adoption,
        NTILE(100) OVER (ORDER BY COALESCE(satisfaction_score, 0)) AS p_satisfaction
    FROM scored s
),
ranked AS (
    SELECT
        n.*,
        ROUND(
            (
                0.25 * p_questions +
                0.20 * p_growth +
                0.15 * p_quality +
                0.15 * p_engagement +
                0.15 * p_adoption +
                0.10 * p_satisfaction
            ) / 100.0,
            3
        ) AS momentum_score
    FROM normalized n
)
SELECT
    technology_name,
    category,
    questions_last_90d,
    question_growth_rate,
    avg_answers_last_90d,
    strategic_accounts,
    satisfaction_score,
    momentum_score
FROM ranked
ORDER BY momentum_score DESC NULLS LAST
LIMIT 25;
