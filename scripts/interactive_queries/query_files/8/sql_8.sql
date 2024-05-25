-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This script calculates the average of the maximum number of reactions per post.
-- The average is calculated by first grouping the reactions by post_id and counting the number of reactions per post.
-- The maximum number of reactions per post is then calculated by grouping the counts by post_id and taking the maximum count.
-- Finally, the average of the maximum reactions per post is calculated by taking the average of the maximum counts.
SELECT
    AVG(Max_Reactions) AS Average_of_Max_Reactions
FROM (
    SELECT
        post_id,
        MAX(reactions_count) AS Max_Reactions
    FROM (
        SELECT
            post_id,
            COUNT(*) AS reactions_count
        FROM
            Reactions
        GROUP BY
            post_id) AS ReactionCounts
    GROUP BY
        post_id) AS MaxCounts;

