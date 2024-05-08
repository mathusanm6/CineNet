-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at self-join to retrieve followers.
-- This query selects followers and followed users based on a given username.
-- It joins the Users table with the Following table to retrieve the follower and followed usernames.
SELECT
    A.username AS Follower,
    B.username AS Followed
FROM
    Users A
    JOIN FOLLOWING F ON A.id = F.follower_id
    JOIN Users B ON F.followed_id = B.id
WHERE
    B.username = :username;

