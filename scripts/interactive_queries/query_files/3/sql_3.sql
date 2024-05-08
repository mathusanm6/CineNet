-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at correlated subquery to retrieve users with at least a minimum number of followers.
-- This query selects users with a count of followers greater than a specified minimum count.
-- It uses a correlated subquery to count the number of followers for each user and filters the results.
SELECT
    username,
(
        SELECT
            COUNT(*)
        FROM
            FOLLOWING F
        WHERE
            F.follower_id = U.id) AS Following_Count
FROM
    Users U
WHERE (
    SELECT
        COUNT(*)
    FROM
        FOLLOWING F
    WHERE
        F.follower_id = U.id) >= :minfollowingcount;

