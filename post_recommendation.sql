-- Set the search path to our cinenet schema
SET search_path TO cinenet;

-- Drop existing table if it exists
DROP TABLE IF EXISTS PostSimilarities;

-- Create a new table to store post similarities
CREATE TABLE PostSimilarities(
    post_id1 integer NOT NULL,
    post_id2 integer NOT NULL,
    similarity numeric NOT NULL,
    PRIMARY KEY (post_id1, post_id2)
);

-- Define a function to assign weights to reactions
CREATE OR REPLACE FUNCTION reaction_to_weight(reaction varchar(10))
    RETURNS numeric
    AS $$
BEGIN
    RETURN CASE WHEN reaction = '😄' THEN
        5 -- Excellent
    WHEN reaction = '🙂' THEN
        4 -- Good
    WHEN reaction = '😐' THEN
        3 -- Average
    WHEN reaction = '🙁' THEN
        2 -- Poor
    WHEN reaction = '😩' THEN
        1 -- Terrible
    ELSE
        0 -- In case of unrecognized emoji
    END;
END;
$$
LANGUAGE plpgsql;

-- Insert calculated similarities between posts based on reactions
INSERT INTO PostSimilarities(post_id1, post_id2, similarity)
SELECT
    a.post_id AS post_id1,
    b.post_id AS post_id2,
(SUM(reaction_to_weight(a.emoji) * reaction_to_weight(b.emoji)) /(SQRT(SUM(POWER(reaction_to_weight(a.emoji), 2))) * SQRT(SUM(POWER(reaction_to_weight(b.emoji), 2))))) AS similarity
FROM
    Reactions a
    JOIN Reactions b ON a.user_id = b.user_id
        AND a.post_id <> b.post_id
GROUP BY
    a.post_id,
    b.post_id
HAVING
    COUNT(a.user_id) > 1;

-- Ensure enough overlap for meaningful similarity
-- Drop temporary table if it exists
DROP TABLE IF EXISTS PostRecommendationTemp;

-- Create a temporary table to calculate and store post recommendations
CREATE TEMP TABLE PostRecommendationTemp AS
SELECT
    u.id AS user_id,
    s.post_id2 AS post_id,
    SUM(s.similarity * reaction_to_weight(r.emoji)) / SUM(ABS(s.similarity)) AS score_recommendation
FROM
    Reactions r
    JOIN PostSimilarities s ON r.post_id = s.post_id1
    JOIN Users u ON u.id = r.user_id
    LEFT JOIN Reactions rm ON u.id = rm.user_id
        AND s.post_id2 = rm.post_id
WHERE
    rm.post_id IS NULL -- Include only posts that the user hasn't reacted to yet
GROUP BY
    u.id,
    s.post_id2
HAVING
    SUM(ABS(s.similarity)) > 0;

-- Ensure that recommendations are based on significant similarities
-- Insert recommendations into the permanent table, updating existing entries if necessary
INSERT INTO PostRecommendation(user_id, post_id, score_recommendation)
SELECT
    user_id,
    post_id,
    score_recommendation
FROM
    PostRecommendationTemp
ON CONFLICT (user_id,
    post_id)
    DO UPDATE SET
        score_recommendation = EXCLUDED.score_recommendation;

