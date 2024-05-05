-- Set the search path to our cine_net schema
SET
    search_path TO cine_net;

-- Drop existing table if it exists
DROP TABLE IF EXISTS EventSimilarities;

-- Create a new table to store event similarities
CREATE TABLE EventSimilarities (
    event_id1 INTEGER NOT NULL,
    event_id2 INTEGER NOT NULL,
    similarity NUMERIC NOT NULL,
    PRIMARY KEY (event_id1, event_id2)
);

-- Insert calculated similarities between events
INSERT INTO
    EventSimilarities (event_id1, event_id2, similarity)
SELECT
    a.event_id AS event_id1,
    b.event_id AS event_id2,
    (
        SUM(a.rating * b.rating) / (SQRT(SUM(POWER(a.rating, 2))) * SQRT(SUM(POWER(b.rating, 2))))
    ) AS similarity
FROM
    UserEventRatings a
    JOIN UserEventRatings b ON a.user_id = b.user_id
    AND a.event_id <> b.event_id
GROUP BY
    a.event_id,
    b.event_id
HAVING
    COUNT(a.user_id) > 1; -- Ensure there is enough user overlap for meaningful similarity

-- Drop temporary table if it exists
DROP TABLE IF EXISTS EventRecommendationTemp;

-- Create a temporary table to calculate and store event recommendations
CREATE TEMP TABLE EventRecommendationTemp AS
SELECT
    u.id AS user_id,
    s.event_id2 AS event_id,
    SUM(s.similarity * r.rating) / SUM(ABS(s.similarity)) AS score_recommendation
FROM
    UserEventRatings r
    JOIN EventSimilarities s ON r.event_id = s.event_id1
    JOIN Users u ON u.id = r.user_id
    LEFT JOIN UserEventRatings rm ON u.id = rm.user_id
    AND s.event_id2 = rm.event_id
WHERE
    rm.event_id IS NULL -- Include only events that the user hasn't rated yet
GROUP BY
    u.id,
    s.event_id2
HAVING
    SUM(ABS(s.similarity)) > 0;

-- Ensure that recommendations are based on significant similarities
-- Insert recommendations into the permanent table, updating existing entries if necessary
INSERT INTO
    EventRecommendation (user_id, event_id, score_recommendation)
SELECT
    user_id,
    event_id,
    score_recommendation
FROM
    EventRecommendationTemp 
    ON CONFLICT (user_id, event_id) DO
UPDATE
SET
    score_recommendation = EXCLUDED.score_recommendation;