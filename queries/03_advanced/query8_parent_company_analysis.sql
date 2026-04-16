-- Compare parent companies vs their subsidiaries' tech portfolios
WITH company_techs AS (
    SELECT 
        c.id,
        c.name,
        c.parent_id,
        COUNT(DISTINCT tc.tag) AS tech_count,
        SUM(s.question_count) AS total_developer_questions
    FROM company c
    LEFT JOIN tag_company tc ON c.id = tc.company_id
    LEFT JOIN stackoverflow s ON tc.tag = s.tag
    GROUP BY c.id, c.name, c.parent_id
)
SELECT 
    parent.name AS parent_company,
    COUNT(child.id) AS num_subsidiaries,
    SUM(child.tech_count) AS total_technologies_across_subsidiaries,
    SUM(child.total_developer_questions) AS total_developer_activity,
    parent.tech_count AS parent_tech_count,
    parent.total_developer_questions AS parent_developer_activity
FROM company_techs parent
JOIN company_techs child ON parent.id = child.parent_id
WHERE parent.parent_id IS NULL
GROUP BY parent.name, parent.tech_count, parent.total_developer_questions
ORDER BY total_developer_activity DESC
LIMIT 10;
