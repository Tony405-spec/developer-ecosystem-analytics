-- Hardest technology per company based on Stack Overflow friction and survey learning curve.
WITH question_friction AS (
    SELECT
        technology_id,
        AVG(CASE WHEN is_answered THEN 1 ELSE 0 END) AS answer_rate,
        AVG(CASE WHEN closed_reason IS NOT NULL THEN 1 ELSE 0 END) AS closed_rate,
        AVG(answer_count) AS avg_answers
    FROM stack_overflow_questions
    GROUP BY technology_id
),
sentiment AS (
    SELECT DISTINCT ON (technology_id)
        technology_id,
        learning_curve
    FROM developer_sentiment
    ORDER BY technology_id, survey_year DESC
),
tech_difficulty AS (
    SELECT
        t.technology_id,
        t.technology_name,
        COALESCE(1 - q.answer_rate, 0) * 0.5 +
        COALESCE(q.closed_rate, 0) * 0.2 +
        COALESCE(s.learning_curve, 0) * 0.3 AS difficulty_score
    FROM technologies t
    LEFT JOIN question_friction q ON q.technology_id = t.technology_id
    LEFT JOIN sentiment s ON s.technology_id = t.technology_id
),
company_stack AS (
    SELECT
        c.company_id,
        c.company_name,
        c.industry,
        cta.technology_id,
        cta.adoption_level,
        cta.adoption_score,
        td.difficulty_score
    FROM companies c
    JOIN company_tech_adoption cta ON cta.company_id = c.company_id
    LEFT JOIN tech_difficulty td ON td.technology_id = cta.technology_id
),
ranked AS (
    SELECT
        cs.*,
        ROW_NUMBER() OVER (PARTITION BY cs.company_id ORDER BY cs.difficulty_score DESC NULLS LAST) AS difficulty_rank
    FROM company_stack cs
)
SELECT
    company_name,
    industry,
    technology_id,
    adoption_level,
    adoption_score,
    difficulty_score
FROM ranked
WHERE difficulty_rank = 1
ORDER BY difficulty_score DESC NULLS LAST;
