-- Parent-company analysis: roll up technology adoption and community footprint by corporate family.
WITH company_tree AS (
    SELECT
        c.company_id,
        c.parent_company_id,
        COALESCE(c.parent_company_id, c.company_id) AS root_company_id
    FROM companies c
),
family_adoption AS (
    SELECT
        ct.root_company_id,
        cta.technology_id,
        COUNT(DISTINCT cta.company_id) AS subsidiaries_using,
        AVG(cta.adoption_score) AS avg_adoption_score
    FROM company_tech_adoption cta
    JOIN company_tree ct ON ct.company_id = cta.company_id
    GROUP BY ct.root_company_id, cta.technology_id
),
family_questions AS (
    SELECT
        ct.root_company_id,
        q.technology_id,
        COUNT(*) AS question_mentions
    FROM company_question_mentions cqm
    JOIN company_tree ct ON ct.company_id = cqm.company_id
    JOIN stack_overflow_questions q ON q.question_id = cqm.question_id
    GROUP BY ct.root_company_id, q.technology_id
),
aggregated AS (
    SELECT
        fa.root_company_id,
        fa.technology_id,
        fa.subsidiaries_using,
        fa.avg_adoption_score,
        fq.question_mentions
    FROM family_adoption fa
    LEFT JOIN family_questions fq
        ON fq.root_company_id = fa.root_company_id
       AND fq.technology_id = fa.technology_id
)
SELECT
    parent.company_name AS parent_company,
    tech.technology_name,
    aggregated.subsidiaries_using,
    aggregated.avg_adoption_score,
    COALESCE(aggregated.question_mentions, 0) AS question_mentions
FROM aggregated
JOIN companies parent ON parent.company_id = aggregated.root_company_id
JOIN technologies tech ON tech.technology_id = aggregated.technology_id
ORDER BY parent.company_name, question_mentions DESC;
