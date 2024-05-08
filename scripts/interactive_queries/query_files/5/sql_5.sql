-- This script sets the search path to the 'cinenet' schema.
set search_path to cinenet;

-- Query that involves one subquery in the WHERE clause.
-- This query selects usernames of users who have posted after a specified date.

SELECT U.username
FROM Users U
WHERE U.id IN (SELECT user_id FROM Posts WHERE date > :date)

