-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that expresses a condition of totality with correlated subqueries.
-- This query retrieves users who have reacted to all posts of a specified user.
-- It uses a correlated subquery to check if there are no posts that the user has not reacted to.
SELECT DISTINCT
    R.user_id
FROM
    Reactions R
WHERE
    NOT EXISTS (
        SELECT
            P.id
        FROM
            Posts P
        WHERE
            P.user_id = :userid
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    Reactions R2
                WHERE
                    R2.user_id = R.user_id
                    AND R2.post_id = P.id));

