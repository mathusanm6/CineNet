-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at one subquery in the FROM clause.
-- This query calculates the average popularity of all users in the database.
-- Popularity is defined as the number of followers a user has.
SELECT
    AVG(Popularity) AS Average_Popularity
FROM (
    SELECT
        COUNT(*) AS Popularity
    FROM
        FOLLOWING
    GROUP BY
        followed_id) AS PopularityScores;

