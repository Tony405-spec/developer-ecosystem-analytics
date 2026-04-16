-- Composite technology health score combining community velocity, adoption, satisfaction, and quality.
WITH base AS (
    SELECT
        tech.technology_id,
        tech.technology_name,
        tech.category,
        COUNT(q.question_id) AS total_questions,
        AVG(q.score) AS avg_question_score,
        AVG(q.answer_count) AS avg_answers,
        AVG(CASE WHEN q.is_answered THEN 1 ELSE 0 END) AS answer_rate,
        AVG(CASE WHEN q.closed_reason IS NOT NULL THEN 1 ELSE 0 END) AS closed_rate,
        SUM(q.view_count) AS total_views
    FROM technologies tech
    LEFT JOIN stack_overflow_questions q ON q.technology_id = tech.technology_id
    GROUP BY tech.technology_id, tech.technology_name, tech.category
),
recent_growth AS (
    SELECT
        technology_id,
        COUNT(*) FILTER (WHERE created_at >= current_date - INTERVAL '90 days') AS questions_90d,
        COUNT(*) FILTER (WHERE created_at < current_date - INTERVAL '90 days'
                         AND created_at >= current_date - INTERVAL '180 days') AS questions_prev_90d
    FROM stack_overflow_questions
    GROUP BY technology_id
),
sentiment AS (
    SELECT DISTINCT ON (technology_id)
        technology_id,
        satisfaction_score,
        adoption_score AS survey_adoption_score,
        learning_curve
    FROM developer_sentiment
    ORDER BY technology_id, survey_year DESC
),
adoption AS (
    SELECT
        technology_id,
        COUNT(DISTINCT company_id) AS adopting_companies,
        AVG(adoption_score) AS avg_adoption_score
    FROM company_tech_adoption
    GROUP BY technology_id
),
assembled AS (
    SELECT
        b.*,
        r.questions_90d,
        r.questions_prev_90d,
        CASE
            WHEN r.questions_prev_90d = 0 THEN 1.0
            ELSE (r.questions_90d - r.questions_prev_90d) / NULLIF(r.questions_prev_90d::numeric, 0)
        END AS growth_rate,
        s.satisfaction_score,
        s.survey_adoption_score,
        s.learning_curve,
        a.adopting_companies,
        a.avg_adoption_score
    FROM base b
    LEFT JOIN recent_growth r ON r.technology_id = b.technology_id
    LEFT JOIN sentiment s ON s.technology_id = b.technology_id
    LEFT JOIN adoption a ON a.technology_id = b.technology_id
),
normalized AS (
    SELECT
        a.*,
        NTILE(100) OVER (ORDER BY COALESCE(a.growth_rate, 0)) AS p_growth,
        NTILE(100) OVER (ORDER BY COALESCE(a.answer_rate, 0)) AS p_answers,
        NTILE(100) OVER (ORDER BY COALESCE(1 - a.closed_rate, 0)) AS p_open_rate,
        NTILE(100) OVER (ORDER BY COALESCE(a.satisfaction_score, 0)) AS p_satisfaction,
        NTILE(100) OVER (ORDER BY COALESCE(a.avg_adoption_score, 0)) AS p_adoption_depth,
        NTILE(100) OVER (ORDER BY COALESCE(a.total_views, 0)) AS p_interest
    FROM assembled a
)
SELECT
    technology_name,
    category,
    total_questions,
    growth_rate,
    answer_rate,
    satisfaction_score,
    avg_adoption_score,
    ROUND(
        (
            0.25 * p_growth +
            0.20 * p_answers +
            0.10 * p_open_rate +
            0.20 * p_satisfaction +
            0.15 * p_adoption_depth +
            0.10 * p_interest
        ) / 100.0,
        3
    ) AS health_score
FROM normalized
ORDER BY health_score DESC NULLS LAST
LIMIT 25;
