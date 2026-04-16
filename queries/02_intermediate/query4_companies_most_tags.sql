-- Find companies that own/manage the most technologies
SELECT 
    c.name AS company_name,
    c.ticker,
    COUNT(DISTINCT tc.tag) AS number_of_technologies
FROM company c
JOIN tag_company tc ON c.id = tc.company_id
GROUP BY c.id, c.name, c.ticker
ORDER BY number_of_technologies DESC
LIMIT 10;
