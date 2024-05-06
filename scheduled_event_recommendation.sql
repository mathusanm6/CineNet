-- Set the search path to our cinenet schema
SET search_path TO cinenet;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS UserSimilarities;

-- Create a new table to store user similarities
CREATE TABLE UserSimilarities (
    user_id1 INTEGER NOT NULL,
    user_id2 INTEGER NOT NULL,
    similarity NUMERIC NOT NULL,
    PRIMARY KEY (user_id1, user_id2)
);

-- Print error if Screenings and MovieRecommendation tables do not exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'screenings') THEN
        RAISE EXCEPTION 'Screenings table does not exist';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'movierecommendation') THEN
        RAISE EXCEPTION 'MovieRecommendation table does not exist';
    END IF;
END $$;

-- Populate UserSimilarities based on shared event participations
INSERT INTO UserSimilarities (user_id1, user_id2, similarity)
SELECT
    p1.user_id AS user_id1,
    p2.user_id AS user_id2,
    COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM Participation WHERE user_id = p1.user_id) AS similarity
FROM
    Participation p1
JOIN
    Participation p2 ON p1.event_id = p2.event_id AND p1.user_id <> p2.user_id
GROUP BY
    p1.user_id, p2.user_id;

-- Drop existing temporary recommendation table if it exists
DROP TABLE IF EXISTS ScheduledEventRecommendationTemp;

-- Create a temporary table to calculate and store event recommendations including movie preferences
CREATE TEMP TABLE ScheduledEventRecommendationTemp AS
SELECT
    us.user_id1 AS user_id,
    p.event_id,
    SUM(us.similarity) AS base_score,
    COALESCE(SUM(mr.score_recommendation), 0) AS movie_score,  -- Add movie recommendation score
    SUM(us.similarity) + COALESCE(SUM(mr.score_recommendation), 0) AS recommendation_score  -- Adjusted score including movie preferences
FROM
    UserSimilarities us
JOIN
    Participation p ON us.user_id2 = p.user_id
JOIN
    Events e ON p.event_id = e.id AND e.status = 'Scheduled'
LEFT JOIN
    Participation p2 ON us.user_id1 = p2.user_id AND p.event_id = p2.event_id
LEFT JOIN
    Screenings s ON p.event_id = s.event_id
LEFT JOIN
    MovieRecommendation mr ON us.user_id1 = mr.user_id AND s.movie_id = mr.movie_id
WHERE
    p2.user_id IS NULL  -- Ensure the recommended event isn't already participated in or interested by user_id1
GROUP BY
    us.user_id1, p.event_id;

-- Insert recommendations into a permanent table, updating existing entries if necessary
INSERT INTO ScheduledEventRecommendation (user_id, event_id, score_recommendation)
SELECT
    user_id,
    event_id,
    recommendation_score
FROM
    ScheduledEventRecommendationTemp
ON CONFLICT (user_id, event_id) DO UPDATE
SET
    score_recommendation = EXCLUDED.score_recommendation;
