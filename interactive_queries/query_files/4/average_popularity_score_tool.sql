-- This script sets the search path to the 'cinenet' schema.
set search_path to cinenet;

-- Query that involves at one subquery in the FROM clause.
-- This query calculates the average popularity of all users in the database.
-- Popularity is defined as the number of followers a user has.

SELECT AVG(Popularity) as Average_Popularity
FROM (SELECT COUNT(*) as Popularity FROM Following GROUP BY followed_id) as PopularityScores;
