-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at correlated subquery to retrieve users that follow a minimum number of other users.
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

