-- Set the search path to our cine_net schema
SET search_path TO cine_net;

-- Drop existing table if it exists
DROP TABLE IF EXISTS MovieSimilarities;
-- Create a new table to store movie similarities
CREATE TABLE MovieSimilarities (
    movie_id1 INTEGER NOT NULL,
    movie_id2 INTEGER NOT NULL,
    similarity NUMERIC NOT NULL,
    PRIMARY KEY (movie_id1, movie_id2)
);

-- Insert calculated similarities between movies
INSERT INTO MovieSimilarities (movie_id1, movie_id2, similarity)
SELECT a.movie_id AS movie_id1, b.movie_id AS movie_id2,
       (SUM(a.rating * b.rating) / (SQRT(SUM(a.rating^2)) * SQRT(SUM(b.rating^2)))) AS similarity
FROM UserMovieRatings a
JOIN UserMovieRatings b ON a.user_id = b.user_id AND a.movie_id <> b.movie_id
GROUP BY a.movie_id, b.movie_id
HAVING COUNT(a.user_id) > 1;  -- Ensure enough overlap for meaningful similarity

-- Drop temporary table if it exists
DROP TABLE IF EXISTS MovieRecommendationTemp;
-- Create a temporary table to calculate and store movie recommendations
CREATE TEMP TABLE MovieRecommendationTemp AS
SELECT 
    u.id AS user_id,
    s.movie_id2 AS movie_id,
    SUM(s.similarity * r.rating) / SUM(ABS(s.similarity)) AS score_recommendation
FROM 
    UserMovieRatings r
JOIN 
    MovieSimilarities s ON r.movie_id = s.movie_id1
JOIN 
    Users u ON u.id = r.user_id
LEFT JOIN 
    UserMovieRatings rm ON u.id = rm.user_id AND s.movie_id2 = rm.movie_id
WHERE 
    rm.movie_id IS NULL -- Include only movies that the user hasn't rated yet
GROUP BY 
    u.id, s.movie_id2
HAVING 
    SUM(ABS(s.similarity)) > 0; -- Ensure that recommendations are based on significant similarities

-- Insert recommendations into the permanent table, updating existing entries if necessary
INSERT INTO MovieRecommendation (user_id, movie_id, score_recommendation)
SELECT user_id, movie_id, score_recommendation
FROM MovieRecommendationTemp
ON CONFLICT (user_id, movie_id) DO UPDATE
SET score_recommendation = EXCLUDED.score_recommendation;
