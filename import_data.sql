-- Import des données pour UserRoles
CREATE TEMP TABLE temp_userroles (
    name VARCHAR(255),
    description TEXT
);

COPY temp_userroles(name, description)
FROM '/home/raoul/BD6/ProjetBD6/CSV/userroles.csv' CSV HEADER;

INSERT INTO UserRoles (name, description)
SELECT name, description FROM temp_userroles;

DROP TABLE IF EXISTS temp_userroles;

-- Import des données pour Users
CREATE TEMP TABLE temp_users (
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    username VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    birth_date DATE,
    role_type INTEGER
);

COPY temp_users(last_name, first_name, username, email, password, birth_date, role_type)
FROM '/home/raoul/BD6/ProjetBD6/CSV/users.csv' CSV HEADER;

INSERT INTO Users (last_name, first_name, username, email, password, birth_date, role_type)
SELECT last_name, first_name, username, email, password, birth_date, role_type FROM temp_users;

DROP TABLE IF EXISTS temp_users;

-- Import des données pour Countries
CREATE TEMP TABLE temp_countries (
    country_code CHAR(3),
    name VARCHAR(255)
);

COPY temp_countries(country_code, name)
FROM '/home/raoul/BD6/ProjetBD6/CSV/countries.csv' CSV HEADER;

INSERT INTO Countries (country_code, name)
SELECT country_code, name FROM temp_countries;

DROP TABLE IF EXISTS temp_countries;

-- Import des données pour Cities
CREATE TEMP TABLE temp_cities (
    name VARCHAR(255),
    country_code CHAR(3)
);

COPY temp_cities(name, country_code)
FROM '/home/raoul/BD6/ProjetBD6/CSV/cities.csv' CSV HEADER;

INSERT INTO Cities (name, country_code)
SELECT name, country_code FROM temp_cities;

DROP TABLE IF EXISTS temp_cities;

-- Import des données pour UserLocation
CREATE TEMP TABLE temp_userlocation (
    user_id INTEGER,
    city_code INTEGER
);

COPY temp_userlocation(user_id, city_code)
FROM '/home/raoul/BD6/ProjetBD6/CSV/userlocation.csv' CSV HEADER;

INSERT INTO UserLocation (user_id, city_code)
SELECT user_id, city_code FROM temp_userlocation;

DROP TABLE IF EXISTS temp_userlocation;

-- Import des données pour Friendship
CREATE TEMP TABLE temp_friendship (
    initiator_id INTEGER,
    recipient_id INTEGER,
    date TIMESTAMP
);

COPY temp_friendship(initiator_id, recipient_id, date)
FROM '/home/raoul/BD6/ProjetBD6/CSV/friendship.csv' CSV HEADER;

INSERT INTO Friendship (initiator_id, recipient_id, date)
SELECT initiator_id, recipient_id, date FROM temp_friendship;

DROP TABLE IF EXISTS temp_friendship;

-- Import des données pour Following
CREATE TEMP TABLE temp_following (
    follower_id INTEGER,
    followed_id INTEGER,
    date TIMESTAMP
);

COPY temp_following(follower_id, followed_id, date)
FROM '/home/raoul/BD6/ProjetBD6/CSV/following.csv' CSV HEADER;

INSERT INTO Following (follower_id, followed_id, date)
SELECT follower_id, followed_id, date FROM temp_following;

DROP TABLE IF EXISTS temp_following;

-- Import des données pour Categories
CREATE TEMP TABLE temp_categories (
    name VARCHAR(255),
    description TEXT
);

COPY temp_categories(name, description)
FROM '/home/raoul/BD6/ProjetBD6/CSV/categories.csv' CSV HEADER;

INSERT INTO Categories (name, description)
SELECT name, description FROM temp_categories;

DROP TABLE IF EXISTS temp_categories;

-- Import des données pour Posts
CREATE TEMP TABLE temp_posts (
    user_id INTEGER,
    date TIMESTAMP,
    content TEXT,
    parent_post_id INTEGER,
    category_id INTEGER
);

COPY temp_posts(user_id, date, content, parent_post_id, category_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/posts.csv' CSV HEADER;

INSERT INTO Posts (user_id, date, content, parent_post_id, category_id)
SELECT user_id, date, content, parent_post_id, category_id FROM temp_posts;

DROP TABLE IF EXISTS temp_posts;

-- Import des données pour Tags
CREATE TEMP TABLE temp_tags (
    name VARCHAR(255)
);

COPY temp_tags(name)
FROM '/home/raoul/BD6/ProjetBD6/CSV/tags.csv' CSV HEADER;

INSERT INTO Tags (name)
SELECT name FROM temp_tags;

DROP TABLE IF EXISTS temp_tags;

-- Import des données pour PostTags
CREATE TEMP TABLE temp_posttags (
    tag_id INTEGER,
    post_id INTEGER
);

COPY temp_posttags(tag_id, post_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/posttags.csv' CSV HEADER;

INSERT INTO PostTags (tag_id, post_id)
SELECT tag_id, post_id FROM temp_posttags;

DROP TABLE IF EXISTS temp_posttags;

-- Import des données pour Reactions
CREATE TEMP TABLE temp_reactions (
    user_id INTEGER,
    post_id INTEGER,
    emoji VARCHAR(10)
);

COPY temp_reactions(user_id, post_id, emoji)
FROM '/home/raoul/BD6/ProjetBD6/CSV/reactions.csv' CSV HEADER;

INSERT INTO Reactions (user_id, post_id, emoji)
SELECT user_id, post_id, emoji FROM temp_reactions;

DROP TABLE IF EXISTS temp_reactions;

-- Import des données pour Events
CREATE TEMP TABLE temp_events (
    name VARCHAR(255),
    date TIMESTAMP,
    city_code INTEGER,
    organizer_id INTEGER,
    capacity INTEGER,
    ticket_price NUMERIC,
    status VARCHAR(255)
);

COPY temp_events(name, date, city_code, organizer_id, capacity, ticket_price, status)
FROM '/home/raoul/BD6/ProjetBD6/CSV/events.csv' CSV HEADER;

INSERT INTO Events (name, date, city_code, organizer_id, capacity, ticket_price, status)
SELECT name, date, city_code, organizer_id, capacity, ticket_price, status FROM temp_events;

DROP TABLE IF EXISTS temp_events;

-- Import des données pour Participation
CREATE TEMP TABLE temp_participation (
    user_id INTEGER,
    event_id INTEGER,
    type_participation VARCHAR(255)
);

COPY temp_participation(user_id, event_id, type_participation)
FROM '/home/raoul/BD6/ProjetBD6/CSV/participation.csv' CSV HEADER;

INSERT INTO Participation (user_id, event_id, type_participation)
SELECT user_id, event_id, type_participation FROM temp_participation;

DROP TABLE IF EXISTS temp_participation;

-- Import des données pour Genres
CREATE TEMP TABLE temp_genres (
    name VARCHAR(255),
    parent_genre_id INTEGER
);

COPY temp_genres(name, parent_genre_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/genres.csv' CSV HEADER;

INSERT INTO Genres (name, parent_genre_id)
SELECT name, parent_genre_id FROM temp_genres;

DROP TABLE IF EXISTS temp_genres;

-- Import des données pour Studios
CREATE TEMP TABLE temp_studios (
    name VARCHAR(255)
);

COPY temp_studios(name)
FROM '/home/raoul/BD6/ProjetBD6/CSV/studios.csv' CSV HEADER;

INSERT INTO Studios (name)
SELECT name FROM temp_studios;

DROP TABLE IF EXISTS temp_studios;

-- Import des données pour Movies
CREATE TEMP TABLE temp_movies (
    title VARCHAR(255),
    duration INTEGER,
    release_date DATE
);

COPY temp_movies(title, duration, release_date)
FROM '/home/raoul/BD6/ProjetBD6/CSV/movies.csv' CSV HEADER;

INSERT INTO Movies (title, duration, release_date)
SELECT title, duration, release_date FROM temp_movies;

DROP TABLE IF EXISTS temp_movies;

-- Import des données pour MovieGenres
CREATE TEMP TABLE temp_moviegenres (
    movie_id INTEGER,
    genre_id INTEGER
);

COPY temp_moviegenres(movie_id, genre_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/moviegenres.csv' CSV HEADER;

INSERT INTO MovieGenres (movie_id, genre_id)
SELECT movie_id, genre_id FROM temp_moviegenres;

DROP TABLE IF EXISTS temp_moviegenres;

-- Import des données pour MovieStudios
CREATE TEMP TABLE temp_moviestudios (
    movie_id INTEGER,
    studio_id INTEGER
);

COPY temp_moviestudios(movie_id, studio_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/moviestudios.csv' CSV HEADER;

INSERT INTO MovieStudios (movie_id, studio_id)
SELECT movie_id, studio_id FROM temp_moviestudios;

DROP TABLE IF EXISTS temp_moviestudios;

-- Import des données pour People
CREATE TEMP TABLE temp_people (
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    birth_date DATE
);

COPY temp_people(last_name, first_name, birth_date)
FROM '/home/raoul/BD6/ProjetBD6/CSV/people.csv' CSV HEADER;

INSERT INTO People (last_name, first_name, birth_date)
SELECT last_name, first_name, birth_date FROM temp_people;

DROP TABLE IF EXISTS temp_people;

-- Import des données pour PeopleRoles
CREATE TEMP TABLE temp_peopleroles (
    name VARCHAR(255)
);

COPY temp_peopleroles(name)
FROM '/home/raoul/BD6/ProjetBD6/CSV/peopleroles.csv' CSV HEADER;

INSERT INTO PeopleRoles (name)
SELECT name FROM temp_peopleroles;

DROP TABLE IF EXISTS temp_peopleroles;

-- Import des données pour MovieCollaborators
CREATE TEMP TABLE temp_moviecollaborators (
    movie_id INTEGER,
    people_id INTEGER,
    role_id INTEGER
);

COPY temp_moviecollaborators(movie_id, people_id, role_id)
FROM '/home/raoul/BD6/ProjetBD6/CSV/moviecollaborators.csv' CSV HEADER;

INSERT INTO MovieCollaborators (movie_id, people_id, role_id)
SELECT movie_id, people_id, role_id FROM temp_moviecollaborators;

DROP TABLE IF EXISTS temp_moviecollaborators;

-- Import des données pour UserEventRatings
CREATE TEMP TABLE temp_usereventratings (
    user_id INTEGER,
    event_id INTEGER,
    rating INTEGER
);

COPY temp_usereventratings(user_id, event_id, rating)
FROM '/home/raoul/BD6/ProjetBD6/CSV/usereventratings.csv' CSV HEADER;

INSERT INTO UserEventRatings (user_id, event_id, rating)
SELECT user_id, event_id, rating FROM temp_usereventratings;

DROP TABLE IF EXISTS temp_usereventratings;

-- Import des données pour UserMovieRatings
CREATE TEMP TABLE temp_usermovieratings (
    user_id INTEGER,
    movie_id INTEGER,
    rating INTEGER
);

COPY temp_usermovieratings(user_id, movie_id, rating)
FROM '/home/raoul/BD6/ProjetBD6/CSV/usermovieratings.csv' CSV HEADER;

INSERT INTO UserMovieRatings (user_id, movie_id, rating)
SELECT user_id, movie_id, rating FROM temp_usermovieratings;

DROP TABLE IF EXISTS temp_usermovieratings;

-- Import des données pour MovieRecommendation
CREATE TEMP TABLE temp_movierecommendation (
    user_id INTEGER,
    movie_id INTEGER,
    score_recommendation FLOAT
);

COPY temp_movierecommendation(user_id, movie_id, score_recommendation)
FROM '/home/raoul/BD6/ProjetBD6/CSV/movierecommendation.csv' CSV HEADER;

INSERT INTO MovieRecommendation (user_id, movie_id, score_recommendation)
SELECT user_id, movie_id, score_recommendation FROM temp_movierecommendation;

DROP TABLE IF EXISTS temp_movierecommendation;

-- Import des données pour EventRecommendation
CREATE TEMP TABLE temp_eventrecommendation (
    user_id INTEGER,
    event_id INTEGER,
    score_recommendation FLOAT
);

COPY temp_eventrecommendation(user_id, event_id, score_recommendation)
FROM '/home/raoul/BD6/ProjetBD6/CSV/eventrecommendation.csv' CSV HEADER;

INSERT INTO EventRecommendation (user_id, event_id, score_recommendation)
SELECT user_id, event_id, score_recommendation FROM temp_eventrecommendation;

DROP TABLE IF EXISTS temp_eventrecommendation;