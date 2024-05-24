-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query retrieves the number of posts made by each user.
-- The result includes the username and the total number of posts.
SELECT
    U.username,
    PostCount.PostsCount
FROM
    Users U
    JOIN (
        SELECT
            user_id,
            COUNT(*) AS PostsCount
        FROM
            Posts
        GROUP BY
            user_id) PostCount ON U.id = PostCount.user_id;

