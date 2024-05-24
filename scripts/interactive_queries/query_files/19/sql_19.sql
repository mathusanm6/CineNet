-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query returns the cities that host at least one event with at least movie longer than 1h30.
-- It calculates the average duration of the movies projected in these cities.
-- The result includes the city name and the average duration of the movies.
SELECT
    CI.name AS City_Name,
    AVG(CAST(M.duration AS real)) AS Average_Duration
FROM
    Screenings S
    JOIN Movies M ON S.movie_id = M.id
    JOIN Events E ON S.event_id = E.id
    JOIN Cities CI ON E.city_code = CI.city_code
WHERE
    M.duration > 90
GROUP BY
    CI.name;

