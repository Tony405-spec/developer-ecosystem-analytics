-- Company technology stack diversity using Shannon entropy across categories.
WITH company_stack AS (
    SELECT
        c.company_id,
        c.company_name,
        tech.category,
        COUNT(*) AS tech_count
    FROM company_tech_adoption cta
    JOIN companies c ON c.company_id = cta.company_id
    JOIN technologies tech ON tech.technology_id = cta.technology_id
    GROUP BY c.company_id, c.company_name, tech.category
),
share AS (
    SELECT
        company_id,
        company_name,
        category,
        tech_count,
        tech_count::numeric / NULLIF(SUM(tech_count) OVER (PARTITION BY company_id), 0) AS pct_category
    FROM company_stack
),
entropy AS (
    SELECT
        company_id,
        company_name,
        COUNT(*) AS categories,
        -SUM(pct_category * LN(pct_category)) / NULLIF(LN(COUNT(*)), 0) AS normalized_entropy
    FROM share
    GROUP BY company_id, company_name
)
SELECT
    e.company_name,
    e.categories AS category_breadth,
    ROUND(e.normalized_entropy, 3) AS diversity_index
FROM entropy e
ORDER BY diversity_index DESC NULLS LAST
LIMIT 25;
