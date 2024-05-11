-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query returns the next scheduled event from the 'Events' table.
-- It uses a recursive CTE to generate a sequence of dates starting from today.
-- The query then joins this sequence with the 'Events' table to find the next scheduled event.
-- The result includes the event name, full datetime, and status.
WITH RECURSIVE DateSeq AS (
    SELECT
        NOW()::date AS event_date -- Start from today, only the date part
    UNION ALL
    SELECT
        (event_date + INTERVAL '1 day')::date
    FROM
        DateSeq
    WHERE
        event_date <(
            SELECT
                MAX(date)::date
            FROM
                Events)
            -- Up to the max date only, ignoring time
)
SELECT
    COALESCE(E.name, 'No event scheduled') AS event_name,
    E.date AS event_full_datetime,
    E.status
FROM
    DateSeq
    LEFT JOIN Events E ON DateSeq.event_date = E.date::date -- Compare only the date parts
WHERE
    DateSeq.event_date >= NOW()::date
    AND E.status = 'Scheduled'
    AND E.id IS NOT NULL
ORDER BY
    DateSeq.event_date ASC
LIMIT 1;

