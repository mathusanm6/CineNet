-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that calculates the average popularity of all users per country.
-- Popularity is defined as the number of followers a user has.
SELECT
    CO.name AS Country_Name,
    AVG(PopularityScores.Popularity) AS Average_Popularity
FROM
    Countries AS CO
    JOIN (
        SELECT
            COUNT(*) AS Popularity,
            UL.city_code
        FROM
            FOLLOWING AS F
            JOIN Users AS U ON F.followed_id = U.id
            JOIN UserLocations AS UL ON U.id = UL.user_id
        GROUP BY
            UL.city_code) AS PopularityScores ON CO.country_code =(
        SELECT
            country_code
        FROM
            Cities
        WHERE
            city_code = PopularityScores.city_code)
GROUP BY
    CO.name;

