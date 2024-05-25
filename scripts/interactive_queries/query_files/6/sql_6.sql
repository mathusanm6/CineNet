-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves an aggregate function with a GROUP BY clause and a HAVING clause.
-- This query selects the name of each country and the number of users in each country.
-- It only includes countries with a user count greater than or equal to the specified minimum user count.
SELECT
    CO.name,
    COUNT(*) AS User_Count
FROM
    UserLocations UL
    JOIN Cities C ON UL.city_code = C.city_code
    JOIN Countries CO ON C.country_code = CO.country_code
GROUP BY
    CO.name
HAVING
    COUNT(*) >= :minusercount;

