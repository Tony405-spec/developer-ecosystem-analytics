-- Companies associated with the highest volume of Stack Overflow question tags.
-- Uses company_question_mentions mapping (company_id -> question_id) plus question tags.
WITH company_tags AS (
    SELECT
        cqm.company_id,
        qt.tag,
        COUNT(*) AS tag_mentions
    FROM company_question_mentions cqm
    JOIN stack_overflow_question_tags qt ON qt.question_id = cqm.question_id
    GROUP BY cqm.company_id, qt.tag
),
ranked AS (
    SELECT
        company_id,
        tag,
        tag_mentions,
        ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY tag_mentions DESC) AS tag_rank
    FROM company_tags
),
summary AS (
    SELECT
        company_id,
        SUM(tag_mentions) AS total_tag_mentions,
        COUNT(DISTINCT tag) AS distinct_tags
    FROM company_tags
    GROUP BY company_id
)
SELECT
    co.company_name,
    co.industry,
    co.fortune_rank,
    s.total_tag_mentions,
    s.distinct_tags,
    r.tag AS top_tag,
    r.tag_mentions AS top_tag_mentions
FROM summary s
JOIN companies co ON co.company_id = s.company_id
LEFT JOIN ranked r ON r.company_id = s.company_id AND r.tag_rank = 1
ORDER BY s.total_tag_mentions DESC
LIMIT 25;
