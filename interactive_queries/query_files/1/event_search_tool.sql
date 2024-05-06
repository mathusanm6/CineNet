-- This script sets the search path to the 'cinenet' schema.
set search_path to cinenet;

-- Query that involves at least three tables to retrieve events.
-- This query selects the username of users who are participating in an scheduled event in a specific country.
-- It joins the Users, UserLocations, Cities, Countries, Participation, and Events tables to retrieve the required information.

SELECT U.username, E.date
FROM Users U
JOIN UserLocations UL ON U.id = UL.user_id
JOIN Cities C ON UL.city_code = C.city_code
JOIN Countries CO ON C.country_code = CO.country_code
JOIN Participation P ON U.id = P.user_id
JOIN Events E ON P.event_id = E.id
WHERE E.status = 'Scheduled' and P.type_participation = 'Participating' and E.name = :eventname and CO.name = :countryname;
