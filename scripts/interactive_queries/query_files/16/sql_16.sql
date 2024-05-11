-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query returns the top 10 events with the most participants in a given year.
-- It uses a window function to rank events by the number of participants in descending order.
-- The result includes the event name, date, and rank.
-- The query filters events by the specified year and orders the results by rank and date.
SELECT DISTINCT
    E.name,
    E.date,
    RANK() OVER (PARTITION BY EXTRACT(MONTH FROM E.date) ORDER BY COUNT(P.user_id) DESC) AS Rank
FROM
    Events E
    JOIN Participation P ON E.id = P.event_id
GROUP BY
    E.name,
    E.date
HAVING
    EXTRACT(YEAR FROM E.date) = :year
ORDER BY
    Rank ASC,
    E.date ASC
LIMIT 10;

