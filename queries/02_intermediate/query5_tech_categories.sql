-- Category-level rollup showing adoption breadth and engagement.
WITH category_metrics AS (
    SELECT
        tech.category,
        COUNT(DISTINCT tech.technology_id) AS technologies,
        COUNT(*) FILTER (WHERE q.question_id IS NOT NULL) AS total_questions,
        AVG(q.score) AS avg_question_score,
        AVG(q.answer_count) AS avg_answers,
        SUM(q.view_count) AS total_views
    FROM technologies tech
    LEFT JOIN stack_overflow_questions q ON q.technology_id = tech.technology_id
    GROUP BY tech.category
),
category_adoption AS (
    SELECT
        tech.category,
        COUNT(DISTINCT cta.company_id) AS adopting_companies,
        AVG(cta.adoption_score) AS avg_adoption_score
    FROM technologies tech
    JOIN company_tech_adoption cta ON cta.technology_id = tech.technology_id
    GROUP BY tech.category
)
SELECT
    m.category,
    m.technologies,
    m.total_questions,
    m.avg_question_score,
    m.avg_answers,
    m.total_views,
    a.adopting_companies,
    a.avg_adoption_score
FROM category_metrics m
LEFT JOIN category_adoption a ON a.category = m.category
ORDER BY total_questions DESC NULLS LAST;
