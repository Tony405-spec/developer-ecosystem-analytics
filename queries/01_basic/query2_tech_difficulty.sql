-- Technologies ranked by learning difficulty using survey responses and Stack Overflow friction.
WITH question_friction AS (
    SELECT
        technology_id,
        COUNT(*) AS questions_total,
        AVG(answer_count) AS avg_answers,
        AVG(score) AS avg_score,
        AVG(CASE WHEN is_answered THEN 1 ELSE 0 END) AS answer_rate,
        AVG(CASE WHEN closed_reason IS NOT NULL THEN 1 ELSE 0 END) AS closed_rate
    FROM stack_overflow_questions
    GROUP BY technology_id
),
latest_sentiment AS (
    SELECT DISTINCT ON (technology_id)
        technology_id,
        learning_curve,
        satisfaction_score,
        adoption_score
    FROM developer_sentiment
    ORDER BY technology_id, survey_year DESC
),
combined AS (
    SELECT
        tech.technology_id,
        tech.technology_name,
        tech.category,
        q.questions_total,
        q.avg_answers,
        q.avg_score,
        q.answer_rate,
        q.closed_rate,
        s.learning_curve,
        s.satisfaction_score,
        s.adoption_score
    FROM technologies tech
    LEFT JOIN question_friction q ON q.technology_id = tech.technology_id
    LEFT JOIN latest_sentiment s ON s.technology_id = tech.technology_id
),
scored AS (
    SELECT
        c.*,
        -- Higher difficulty when fewer answers, more closures, steeper learning curve.
        ROUND(
            (
                (1 - COALESCE(c.answer_rate, 0)) * 0.35 +
                COALESCE(c.closed_rate, 0) * 0.25 +
                COALESCE(c.learning_curve, 0) * 0.25 +
                (1 - COALESCE(c.satisfaction_score, 0)) * 0.15
            ),
            3
        ) AS difficulty_score
    FROM combined c
)
SELECT
    technology_name,
    category,
    difficulty_score,
    learning_curve,
    answer_rate,
    closed_rate,
    questions_total
FROM scored
ORDER BY difficulty_score DESC NULLS LAST
LIMIT 25;
