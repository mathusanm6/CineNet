-- This script sets the search path to the 'cinenet' schema.
SET search_path TO cinenet;

-- Query that involves at least one outer join.
-- This query retrieves users with a specified type of participation in events with a specific status.
-- It uses a LEFT JOIN to include users who may not have any participation records.
-- The query joins the Users, Participation, and Events tables to retrieve the required information.
SELECT
    U.username,
    P.type_participation,
    E.name
FROM
    Users U
    LEFT JOIN Participation P ON U.id = P.user_id
        AND P.type_participation = :typeparticipation
    LEFT JOIN Events E ON P.event_id = E.id
        AND E.status = :eventstatus
WHERE
    U.username IS NOT NULL
    AND P.type_participation IS NOT NULL
    AND E.name IS NOT NULL;

