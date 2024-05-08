-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves an aggregate function with a GROUP BY clause and a HAVING clause.
-- This query selects the name of the tag and the number of posts associated with each tag.
-- It only includes tags with a post count greater than or equal to the specified minimum post count
-- and with the specified emoji reaction.
SELECT
    T.name,
    COUNT(DISTINCT P.id) AS Post_Count
FROM
    Tags T
    JOIN PostTags PT ON T.id = PT.tag_id
    JOIN Posts P ON P.id = PT.post_id
    JOIN Reactions R ON R.post_id = P.id
WHERE
    R.emoji = :emoji
GROUP BY
    T.name
HAVING
    COUNT(DISTINCT P.id) >= :minpostcount;

