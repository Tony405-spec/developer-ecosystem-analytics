-- Daily and hourly question patterns by technology.
WITH expanded AS (
    SELECT
        technology_id,
        EXTRACT(DOW FROM created_at)::int AS day_of_week,
        EXTRACT(HOUR FROM created_at)::int AS hour_of_day
    FROM stack_overflow_questions
),
aggregated AS (
    SELECT
        technology_id,
        day_of_week,
        hour_of_day,
        COUNT(*) AS question_count
    FROM expanded
    GROUP BY technology_id, day_of_week, hour_of_day
),
normalized AS (
    SELECT
        a.*,
        ROUND(
            question_count::numeric /
            NULLIF(SUM(question_count) OVER (PARTITION BY technology_id), 0),
            4
        ) AS share_of_week
    FROM aggregated a
)
SELECT
    tech.technology_name,
    day_of_week,
    hour_of_day,
    question_count,
    share_of_week
FROM normalized n
JOIN technologies tech ON tech.technology_id = n.technology_id
ORDER BY tech.technology_name, day_of_week, hour_of_day;
