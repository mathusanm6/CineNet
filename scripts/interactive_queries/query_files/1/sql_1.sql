-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at least three tables to retrieve events.
-- This query selects the username of users who are participating in an scheduled event in a specific city and country
-- where they are located.
-- The query receives two parameters: the name of the event and the name of the city.
SELECT
    U.username,
    E.date
FROM
    Users U
    JOIN UserLocations UL ON U.id = UL.user_id
    JOIN Cities C ON UL.city_code = C.city_code
    JOIN Countries CO ON C.country_code = CO.country_code
    JOIN Participation P ON U.id = P.user_id
    JOIN Events E ON P.event_id = E.id
WHERE
    E.status = 'Scheduled'
    AND P.type_participation = 'Participating'
    AND E.name = :eventname
    AND CO.name = :countryname
    ;

