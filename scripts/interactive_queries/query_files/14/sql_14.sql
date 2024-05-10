-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This script lists the posts that have no parent post.
-- Because of NULL values in the parent_post_id column, we need to use a different approach.
SELECT DISTINCT
    P1.id
FROM
    Posts P1
WHERE
    P1.id NOT IN (
        SELECT
            P2. parent_post_id
        FROM
            Posts P2);

