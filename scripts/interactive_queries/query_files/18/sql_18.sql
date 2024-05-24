-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- This query uses a recursive CTE to find all sub-genres of a specified parent genre.
-- The result includes the genre ID, name, and parent genre ID.
WITH RECURSIVE GenresCurent AS 
(
    SELECT 
        id,
        name,
        parent_genre_id
    FROM 
        Genres
    WHERE
        id = :parent_genre_id
    UNION ALL
    SELECT
        G.id,
        G.name,
        G.parent_genre_id
    FROM
        Genres G,GenresCurent GC
    WHERE GC.id = G.parent_genre_id
)
SELECT * FROM GenresCurent;
