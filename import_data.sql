-- Set the search path to our cine_net schema
SET search_path TO cine_net;

-- Import des données pour UserRoles
CREATE TEMP TABLE temp_userroles (
    name VARCHAR(255),
    description TEXT
);

\copy temp_userroles(name, description) from './CSV/userroles.csv' WITH DELIMITER ',' CSV HEADER;

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

\copy temp_users(last_name, first_name, username, email, password, birth_date, role_type) from './CSV/users.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Users (last_name, first_name, username, email, password, birth_date, role_type)
SELECT last_name, first_name, username, email, password, birth_date, role_type FROM temp_users;

DROP TABLE IF EXISTS temp_users;

-- Import des données pour Countries
CREATE TEMP TABLE temp_countries (
    country_code CHAR(3),
    name VARCHAR(255)
);

\copy temp_countries(country_code, name) from './CSV/countries.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Countries (country_code, name)
SELECT country_code, name FROM temp_countries;

DROP TABLE IF EXISTS temp_countries;

-- Import des données pour Cities
CREATE TEMP TABLE temp_cities (
    name VARCHAR(255),
    country_code CHAR(3)
);

\copy temp_cities(name, country_code) from './CSV/cities.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Cities (name, country_code)
SELECT name, country_code FROM temp_cities;

DROP TABLE IF EXISTS temp_cities;

-- Import des données pour UserLocation
CREATE TEMP TABLE temp_userlocation (
    user_id INTEGER,
    city_code INTEGER
);

\copy temp_userlocation(user_id, city_code) from './CSV/userlocation.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO UserLocation (user_id, city_code)
SELECT user_id, city_code FROM temp_userlocation;

DROP TABLE IF EXISTS temp_userlocation;

-- Import des données pour Friendship
CREATE TEMP TABLE temp_friendship (
    initiator_id INTEGER,
    recipient_id INTEGER,
    date TIMESTAMP
);

\copy temp_friendship(initiator_id, recipient_id, date) from './CSV/friendship.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Friendship (initiator_id, recipient_id, date)
SELECT initiator_id, recipient_id, date FROM temp_friendship;

DROP TABLE IF EXISTS temp_friendship;

-- Import des données pour Following
CREATE TEMP TABLE temp_following (
    follower_id INTEGER,
    followed_id INTEGER,
    date TIMESTAMP
);

\copy temp_following(follower_id, followed_id, date) from './CSV/following.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Following (follower_id, followed_id, date)
SELECT follower_id, followed_id, date FROM temp_following;

DROP TABLE IF EXISTS temp_following;

-- Import des données pour Categories
CREATE TEMP TABLE temp_categories (
    name VARCHAR(255),
    description TEXT
);

\copy temp_categories(name, description) from './CSV/categories.csv' WITH DELIMITER ',' CSV HEADER;

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

\copy temp_posts(user_id, date, content, parent_post_id, category_id) from './CSV/posts.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Posts (user_id, date, content, parent_post_id, category_id)
SELECT user_id, date, content, parent_post_id, category_id FROM temp_posts;

DROP TABLE IF EXISTS temp_posts;

-- Import des données pour Tags
CREATE TEMP TABLE temp_tags (
    name VARCHAR(255)
);

\copy temp_tags(name) from './CSV/tags.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Tags (name)
SELECT name FROM temp_tags;

DROP TABLE IF EXISTS temp_tags;

-- Import des données pour PostTags
CREATE TEMP TABLE temp_posttags (
    tag_id INTEGER,
    post_id INTEGER
);

\copy temp_posttags(tag_id, post_id) from './CSV/posttags.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO PostTags (tag_id, post_id)
SELECT tag_id, post_id FROM temp_posttags;

DROP TABLE IF EXISTS temp_posttags;

-- Import des données pour Reactions
CREATE TEMP TABLE temp_reactions (
    user_id INTEGER,
    post_id INTEGER,
    emoji VARCHAR(10)
);

\copy temp_reactions(user_id, post_id, emoji) from './CSV/reactions.csv' WITH DELIMITER ',' CSV HEADER;

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

\copy temp_events(name, date, city_code, organizer_id, capacity, ticket_price, status) from './CSV/events.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Events (name, date, city_code, organizer_id, capacity, ticket_price, status)
SELECT name, date, city_code, organizer_id, capacity, ticket_price, status FROM temp_events;

DROP TABLE IF EXISTS temp_events;

-- Import des données pour Participation
CREATE TEMP TABLE temp_participation (
    user_id INTEGER,
    event_id INTEGER,
    type_participation VARCHAR(255)
);

\copy temp_participation(user_id, event_id, type_participation) from './CSV/participation.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Participation (user_id, event_id, type_participation)
SELECT user_id, event_id, type_participation FROM temp_participation;

DROP TABLE IF EXISTS temp_participation;

-- Import des données pour Genres
CREATE TEMP TABLE temp_genres (
    name VARCHAR(255),
    parent_genre_id INTEGER
);

\copy temp_genres(name, parent_genre_id) from './CSV/genres.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Genres (name, parent_genre_id)
SELECT name, parent_genre_id FROM temp_genres;

DROP TABLE IF EXISTS temp_genres;

-- Import des données pour Studios
CREATE TEMP TABLE temp_studios (
    name VARCHAR(255)
);

\copy temp_studios(name) from './CSV/studios.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Studios (name)
SELECT name FROM temp_studios;

DROP TABLE IF EXISTS temp_studios;

-- Import des données pour Movies
CREATE TEMP TABLE temp_movies (
    title VARCHAR(255),
    duration INTEGER,
    release_date DATE
);

\copy temp_movies(title, duration, release_date) from './CSV/movies.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Movies (title, duration, release_date)
SELECT title, duration, release_date FROM temp_movies;

DROP TABLE IF EXISTS temp_movies;

-- Import des données pour MovieGenres
CREATE TEMP TABLE temp_moviegenres (
    movie_id INTEGER,
    genre_id INTEGER
);

\copy temp_moviegenres(movie_id, genre_id) from './CSV/moviegenres.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO MovieGenres (movie_id, genre_id)
SELECT movie_id, genre_id FROM temp_moviegenres;

DROP TABLE IF EXISTS temp_moviegenres;

-- Import des données pour MovieStudios
CREATE TEMP TABLE temp_moviestudios (
    movie_id INTEGER,
    studio_id INTEGER
);

\copy temp_moviestudios(movie_id, studio_id) from './CSV/moviestudios.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO MovieStudios (movie_id, studio_id)
SELECT movie_id, studio_id FROM temp_moviestudios;

DROP TABLE IF EXISTS temp_moviestudios;

-- Import des données pour People
CREATE TEMP TABLE temp_people (
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    birth_date DATE
);

\copy temp_people(last_name, first_name, birth_date) from './CSV/people.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO People (last_name, first_name, birth_date)
SELECT last_name, first_name, birth_date FROM temp_people;

DROP TABLE IF EXISTS temp_people;

-- Import des données pour PeopleRoles
CREATE TEMP TABLE temp_peopleroles (
    name VARCHAR(255)
);

\copy temp_peopleroles(name) from './CSV/peopleroles.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO PeopleRoles (name)
SELECT name FROM temp_peopleroles;

DROP TABLE IF EXISTS temp_peopleroles;

-- Import des données pour MovieCollaborators
CREATE TEMP TABLE temp_moviecollaborators (
    movie_id INTEGER,
    people_id INTEGER,
    role_id INTEGER
);

\copy temp_moviecollaborators(movie_id, people_id, role_id) from './CSV/moviecollaborators.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO MovieCollaborators (movie_id, people_id, role_id)
SELECT movie_id, people_id, role_id FROM temp_moviecollaborators;

DROP TABLE IF EXISTS temp_moviecollaborators;

-- Import des données pour Screenings
CREATE TEMP TABLE temp_screenings (
    event_id INTEGER,
    movie_id INTEGER,
    screening_time TIMESTAMP
);

\copy temp_screenings(event_id, movie_id, screening_time) from './CSV/screenings.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO Screenings (event_id, movie_id, screening_time)
SELECT event_id, movie_id, screening_time FROM temp_screenings;

DROP TABLE IF EXISTS temp_screenings;

-- Import des données pour UserEventRatings
CREATE TEMP TABLE temp_usereventratings (
    user_id INTEGER,
    event_id INTEGER,
    rating INTEGER
);

\copy temp_usereventratings(user_id, event_id, rating) from './CSV/usereventratings.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO UserEventRatings (user_id, event_id, rating)
SELECT user_id, event_id, rating FROM temp_usereventratings;

DROP TABLE IF EXISTS temp_usereventratings;

-- Import des données pour UserMovieRatings
CREATE TEMP TABLE temp_usermovieratings (
    user_id INTEGER,
    movie_id INTEGER,
    rating INTEGER
);

\copy temp_usermovieratings(user_id, movie_id, rating) from './CSV/usermovieratings.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO UserMovieRatings (user_id, movie_id, rating)
SELECT user_id, movie_id, rating FROM temp_usermovieratings;

DROP TABLE IF EXISTS temp_usermovieratings;

-- Import des données pour MovieRecommendation
CREATE TEMP TABLE temp_movierecommendation (
    user_id INTEGER,
    movie_id INTEGER,
    score_recommendation FLOAT
);

\copy temp_movierecommendation(user_id, movie_id, score_recommendation) from './CSV/movierecommendation.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO MovieRecommendation (user_id, movie_id, score_recommendation)
SELECT user_id, movie_id, score_recommendation FROM temp_movierecommendation;

DROP TABLE IF EXISTS temp_movierecommendation;

-- Import des données pour EventRecommendation
CREATE TEMP TABLE temp_eventrecommendation (
    user_id INTEGER,
    event_id INTEGER,
    score_recommendation FLOAT
);

\copy temp_eventrecommendation(user_id, event_id, score_recommendation) from './CSV/eventrecommendation.csv' WITH DELIMITER ',' CSV HEADER;

INSERT INTO EventRecommendation (user_id, event_id, score_recommendation)
SELECT user_id, event_id, score_recommendation FROM temp_eventrecommendation;

DROP TABLE IF EXISTS temp_eventrecommendation;