-- Set the search path to our cinenet schema
SET search_path TO cinenet;

-- Import des données pour UserRoles
CREATE TEMP TABLE temp_userroles(
    type SERIAL PRIMARY KEY,
    name varchar(255),
    description text
);

\copy temp_userroles(type, name, description) from './CSV/userroles.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO UserRoles(type, name, description)
SELECT
    type,
    name,
    description
FROM
    temp_userroles;

DROP TABLE IF EXISTS temp_userroles;

-- Import des données pour Users
CREATE TEMP TABLE temp_users(
    id serial PRIMARY KEY,
    last_name varchar(255),
    first_name varchar(255),
    username varchar(255),
    email varchar(255),
    password VARCHAR(255),
    birth_date date,
    role_type integer
);

\copy temp_users(id, last_name, first_name, username, email, password, birth_date, role_type) from './CSV/users.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Users(id, last_name, first_name, username, email, PASSWORD, birth_date, role_type)
SELECT
    id,
    last_name,
    first_name,
    username,
    email,
    PASSWORD,
    birth_date,
    role_type
FROM
    temp_users;

DROP TABLE IF EXISTS temp_users;

-- Import des données pour Countries
CREATE TEMP TABLE temp_countries(
    country_code char(3),
    name varchar(255)
);

\copy temp_countries(country_code, name) from './CSV/countries.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Countries(country_code, name)
SELECT
    country_code,
    name
FROM
    temp_countries;

DROP TABLE IF EXISTS temp_countries;

-- Import des données pour Cities
CREATE TEMP TABLE temp_cities(
    city_code serial PRIMARY KEY,
    name varchar(255),
    country_code char(3)
);

\copy temp_cities(city_code, name, country_code) from './CSV/cities.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Cities(city_code, name, country_code)
SELECT
    city_code,
    name,
    country_code
FROM
    temp_cities;

DROP TABLE IF EXISTS temp_cities;

-- Import des données pour UserLocations
CREATE TEMP TABLE temp_userlocations(
    user_id integer,
    city_code integer
);

\copy temp_userlocations(user_id, city_code) from './CSV/userlocations.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO UserLocations(user_id, city_code)
SELECT
    user_id,
    city_code
FROM
    temp_userlocations;

DROP TABLE IF EXISTS temp_userlocations;

-- Import des données pour Friendship
CREATE TEMP TABLE temp_friendship(
    initiator_id integer,
    recipient_id integer,
    date timestamp
);

\copy temp_friendship(initiator_id, recipient_id, date) from './CSV/friendship.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Friendship(initiator_id, recipient_id, date)
SELECT
    initiator_id,
    recipient_id,
    date
FROM
    temp_friendship;

DROP TABLE IF EXISTS temp_friendship;

-- Import des données pour Following
CREATE TEMP TABLE temp_following(
    follower_id integer,
    followed_id integer,
    date timestamp
);

\copy temp_following(follower_id, followed_id, date) from './CSV/following.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO FOLLOWING (follower_id, followed_id, date)
SELECT
    follower_id,
    followed_id,
    date
FROM
    temp_following;

DROP TABLE IF EXISTS temp_following;

-- Import des données pour Categories
CREATE TEMP TABLE temp_categories(
    id serial PRIMARY KEY,
    name varchar(255),
    description text
);

\copy temp_categories(id, name, description) from './CSV/categories.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Categories(id, name, description)
SELECT
    id,
    name,
    description
FROM
    temp_categories;

DROP TABLE IF EXISTS temp_categories;

-- Import des données pour Posts
CREATE TEMP TABLE temp_posts(
    id serial PRIMARY KEY,
    user_id integer,
    date timestamp,
    content text,
    parent_post_id integer,
    category_id integer
);

\copy temp_posts(id, user_id, date, content, parent_post_id, category_id) from './CSV/posts.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Posts(id, user_id, date, content, parent_post_id, category_id)
SELECT
    id,
    user_id,
    date,
    content,
    parent_post_id,
    category_id
FROM
    temp_posts;

DROP TABLE IF EXISTS temp_posts;

-- Import des données pour Tags
CREATE TEMP TABLE temp_tags(
    id serial PRIMARY KEY,
    name varchar(255)
);

\copy temp_tags(id, name) from './CSV/tags.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Tags(id, name)
SELECT
    id,
    name
FROM
    temp_tags;

DROP TABLE IF EXISTS temp_tags;

-- Import des données pour PostTags
CREATE TEMP TABLE temp_posttags(
    tag_id integer,
    post_id integer
);

\copy temp_posttags(tag_id, post_id) from './CSV/posttags.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO PostTags(tag_id, post_id)
SELECT
    tag_id,
    post_id
FROM
    temp_posttags;

DROP TABLE IF EXISTS temp_posttags;

-- Import des données pour Reactions
CREATE TEMP TABLE temp_reactions(
    user_id integer,
    post_id integer,
    emoji varchar(10)
);

\copy temp_reactions(user_id, post_id, emoji) from './CSV/reactions.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Reactions(user_id, post_id, emoji)
SELECT
    user_id,
    post_id,
    emoji
FROM
    temp_reactions;

DROP TABLE IF EXISTS temp_reactions;

-- Import des données pour Events
CREATE TEMP TABLE temp_events(
    id serial PRIMARY KEY,
    name varchar(255),
    date timestamp,
    city_code integer,
    organizer_id integer,
    capacity integer,
    ticket_price numeric,
    status varchar(255)
);

\copy temp_events(id, name, date, city_code, organizer_id, capacity, ticket_price, status) from './CSV/events.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Events(id, name, date, city_code, organizer_id, capacity, ticket_price, status)
SELECT
    id,
    name,
    date,
    city_code,
    organizer_id,
    capacity,
    ticket_price,
    status
FROM
    temp_events;

DROP TABLE IF EXISTS temp_events;

-- Import des données pour Participation
CREATE TEMP TABLE temp_participation(
    user_id integer,
    event_id integer,
    type_participation varchar(255)
);

\copy temp_participation(user_id, event_id, type_participation) from './CSV/participation.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Participation(user_id, event_id, type_participation)
SELECT
    user_id,
    event_id,
    type_participation
FROM
    temp_participation;

DROP TABLE IF EXISTS temp_participation;

-- Import des données pour Genres
CREATE TEMP TABLE temp_genres(
    id serial PRIMARY KEY,
    name varchar(255),
    parent_genre_id integer
);

\copy temp_genres(id, name, parent_genre_id) from './CSV/genres.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Genres(id, name, parent_genre_id)
SELECT
    id,
    name,
    parent_genre_id
FROM
    temp_genres;

DROP TABLE IF EXISTS temp_genres;

-- Import des données pour Studios
CREATE TEMP TABLE temp_studios(
    id serial PRIMARY KEY,
    name varchar(255)
);

\copy temp_studios(id, name) from './CSV/studios.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Studios(id, name)
SELECT
    id,
    name
FROM
    temp_studios;

DROP TABLE IF EXISTS temp_studios;

-- Import des données pour Movies
CREATE TEMP TABLE temp_movies(
    id serial PRIMARY KEY,
    title varchar(255),
    duration integer,
    release_date date
);

\copy temp_movies(id, title, duration, release_date) from './CSV/movies.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Movies(id, title, duration, release_date)
SELECT
    id,
    title,
    duration,
    release_date
FROM
    temp_movies;

DROP TABLE IF EXISTS temp_movies;

-- Import des données pour MovieGenres
CREATE TEMP TABLE temp_moviegenres(
    movie_id integer,
    genre_id integer
);

\copy temp_moviegenres(movie_id, genre_id) from './CSV/moviegenres.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO MovieGenres(movie_id, genre_id)
SELECT
    movie_id,
    genre_id
FROM
    temp_moviegenres;

DROP TABLE IF EXISTS temp_moviegenres;

-- Import des données pour MovieStudios
CREATE TEMP TABLE temp_moviestudios(
    movie_id integer,
    studio_id integer
);

\copy temp_moviestudios(movie_id, studio_id) from './CSV/moviestudios.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO MovieStudios(movie_id, studio_id)
SELECT
    movie_id,
    studio_id
FROM
    temp_moviestudios;

DROP TABLE IF EXISTS temp_moviestudios;

-- Import des données pour People
CREATE TEMP TABLE temp_people(
    id serial PRIMARY KEY,
    name varchar(255),
    birth_date date
);

\copy temp_people(id, name, birth_date) from './CSV/people.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO People(id, name, birth_date)
SELECT
    id,
    name,
    birth_date
FROM
    temp_people;

DROP TABLE IF EXISTS temp_people;

-- Import des données pour PeopleRoles
CREATE TEMP TABLE temp_peopleroles(
    id serial PRIMARY KEY,
    name varchar(255)
);

\copy temp_peopleroles(id, name) from './CSV/peopleroles.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO PeopleRoles(id, name)
SELECT
    id,
    name
FROM
    temp_peopleroles;

DROP TABLE IF EXISTS temp_peopleroles;

-- Import des données pour MovieCollaborators
CREATE TEMP TABLE temp_moviecollaborators(
    people_id integer,
    movie_id integer,
    role_id integer
);

\copy temp_moviecollaborators(people_id, movie_id, role_id) from './CSV/moviecollaborators.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO MovieCollaborators(people_id, movie_id, role_id)
SELECT
    people_id,
    movie_id,
    role_id
FROM
    temp_moviecollaborators;

DROP TABLE IF EXISTS temp_moviecollaborators;

-- Import des données pour Screenings
CREATE TEMP TABLE temp_screenings(
    event_id integer,
    movie_id integer,
    screening_time timestamp
);

\copy temp_screenings(event_id, movie_id, screening_time) from './CSV/screenings.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Screenings(event_id, movie_id, screening_time)
SELECT
    event_id,
    movie_id,
    screening_time
FROM
    temp_screenings;

DROP TABLE IF EXISTS temp_screenings;

-- Import des données pour UserEventRatings
CREATE TEMP TABLE temp_usereventratings(
    user_id integer,
    event_id integer,
    rating integer
);

\copy temp_usereventratings(user_id, event_id, rating) from './CSV/usereventratings.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO UserEventRatings(user_id, event_id, rating)
SELECT
    user_id,
    event_id,
    rating
FROM
    temp_usereventratings;

DROP TABLE IF EXISTS temp_usereventratings;

-- Import des données pour UserMovieRatings
CREATE TEMP TABLE temp_usermovieratings(
    user_id integer,
    movie_id integer,
    rating integer
);

\copy temp_usermovieratings(user_id, movie_id, rating) from './CSV/usermovieratings.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO UserMovieRatings(user_id, movie_id, rating)
SELECT
    user_id,
    movie_id,
    rating
FROM
    temp_usermovieratings;

DROP TABLE IF EXISTS temp_usermovieratings;

