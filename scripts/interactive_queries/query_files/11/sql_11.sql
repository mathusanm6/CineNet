-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that expresses a condition of totality with an aggregate function.
-- This query retrieves users who have reacted to all posts of a specified user.
SELECT
    R.user_id
FROM
    Reactions R
    JOIN Posts P ON R.post_id = P.id
WHERE
    P.user_id = :userid
GROUP BY
    R.user_id
HAVING
    COUNT(DISTINCT P.id) =(
        SELECT
            COUNT(*)
        FROM
            Posts
        WHERE
            user_id = :userid);

