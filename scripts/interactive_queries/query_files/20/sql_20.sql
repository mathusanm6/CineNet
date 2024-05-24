-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query retrieves the future events with more than 10 participants per month.
-- The result includes the event name, date, and number of participants.
SELECT
    E.name AS Event_Name,
    E.date AS Event_Date,
    COUNT(*) AS Participants_Count
FROM
    Events E
    JOIN Participation P ON E.id = P.event_id
WHERE
    E.date > CURRENT_DATE
GROUP BY
    E.name,
    E.date
HAVING
    COUNT(*) > 10;

