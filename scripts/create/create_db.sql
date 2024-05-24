-- For ease of use, this creates a schema
CREATE SCHEMA IF NOT EXISTS cinenet;

SET search_path TO cinenet;

-- Users and their roles
DROP TABLE IF EXISTS UserRoles CASCADE;

CREATE TABLE UserRoles(
    type INTEGER PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL,
    description text
);

DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE Users(
    id integer PRIMARY KEY,
    last_name varchar(255) NOT NULL,
    first_name varchar(255) NOT NULL,
    username varchar(255) UNIQUE NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    birth_date date CONSTRAINT check_birth_date CHECK (birth_date <= CURRENT_DATE),
    role_type integer NOT NULL REFERENCES UserRoles(type)
);

-- Locations
DROP TABLE IF EXISTS Countries CASCADE;

CREATE TABLE Countries(
    country_code char(3) PRIMARY KEY,
    name varchar(255) NOT NULL
);

DROP TABLE IF EXISTS Cities CASCADE;

CREATE TABLE Cities(
    city_code integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    country_code char(3) NOT NULL REFERENCES Countries(country_code)
);

DROP TABLE IF EXISTS UserLocations CASCADE;

CREATE TABLE UserLocations(
    user_id integer NOT NULL REFERENCES Users(id),
    city_code integer NOT NULL REFERENCES Cities(city_code),
    PRIMARY KEY (user_id, city_code)
);

-- Social interactions
DROP TABLE IF EXISTS Friendship CASCADE;

CREATE TABLE Friendship(
    initiator_id integer NOT NULL REFERENCES Users(id),
    recipient_id integer NOT NULL REFERENCES Users(id) CONSTRAINT friendship_check CHECK (initiator_id != recipient_id),
    date timestamp NOT NULL CONSTRAINT friendship_date_check CHECK (date <= CURRENT_TIMESTAMP),
    PRIMARY KEY (initiator_id, recipient_id)
);

DROP TABLE IF EXISTS Following CASCADE;

CREATE TABLE Following (
    follower_id integer NOT NULL REFERENCES Users(id),
    followed_id integer NOT NULL REFERENCES Users(id) CONSTRAINT following_check CHECK (follower_id != followed_id),
    date timestamp NOT NULL CONSTRAINT following_date_check CHECK (date <= CURRENT_TIMESTAMP),
    PRIMARY KEY (follower_id, followed_id)
);

-- Posts and social media interactions
DROP TABLE IF EXISTS Categories CASCADE;

CREATE TABLE Categories(
    id integer PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL,
    description text
);

DROP TABLE IF EXISTS Posts CASCADE;

CREATE TABLE Posts(
    id integer PRIMARY KEY,
    user_id integer NOT NULL REFERENCES Users(id),
    date timestamp NOT NULL CONSTRAINT post_date_check CHECK (date <= CURRENT_TIMESTAMP),
    content text NOT NULL,
    parent_post_id integer REFERENCES Posts(id),
    category_id integer REFERENCES Categories(id)
);

DROP TABLE IF EXISTS Tags CASCADE;

CREATE TABLE Tags(
    id integer PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS PostTags CASCADE;

CREATE TABLE PostTags(
    tag_id integer NOT NULL REFERENCES Tags(id),
    post_id integer NOT NULL REFERENCES Posts(id),
    PRIMARY KEY (tag_id, post_id)
);

DROP TABLE IF EXISTS Reactions CASCADE;

-- Reactions :
-- Excellent -> "😄",
-- Good -> "🙂",
-- Average -> "😐,
-- "Poor -> "🙁",
-- Terrible -> "😩"
CREATE TABLE Reactions(
    user_id integer NOT NULL REFERENCES Users(id),
    post_id integer NOT NULL REFERENCES Posts(id),
    emoji varchar(10) NOT NULL,
    PRIMARY KEY (user_id, post_id, emoji)
);

-- Events and related entities
DROP TABLE IF EXISTS Events CASCADE;

CREATE TABLE Events(
    id integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    date timestamp NOT NULL,
    city_code integer NOT NULL REFERENCES Cities(city_code),
    organizer_id integer NOT NULL REFERENCES Users(id),
    capacity integer NOT NULL CONSTRAINT check_capacity CHECK (capacity > 0),
    ticket_price numeric NOT NULL CONSTRAINT check_ticket_price CHECK (ticket_price >= 0)
);

-- Enabling different event types (Scheduled, Completed, Cancelled)
ALTER TABLE Events
    ADD COLUMN status VARCHAR(255) NOT NULL DEFAULT 'Scheduled' CONSTRAINT check_status CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'));

DROP TABLE IF EXISTS Participation CASCADE;

CREATE TABLE Participation(
    user_id integer NOT NULL REFERENCES Users(id),
    event_id integer NOT NULL REFERENCES Events(id),
    type_participation varchar(255) NOT NULL CONSTRAINT check_type_participation CHECK (type_participation IN ('Interested', 'Participating')),
    PRIMARY KEY (user_id, event_id)
);

-- Movies, genres, and collaborators
DROP TABLE IF EXISTS Genres CASCADE;

CREATE TABLE Genres(
    id integer PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL,
    parent_genre_id integer REFERENCES Genres(id)
);

DROP TABLE IF EXISTS Studios CASCADE;

CREATE TABLE Studios(
    id integer PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS Movies CASCADE;

CREATE TABLE Movies(
    id integer PRIMARY KEY,
    title varchar(255) NOT NULL,
    duration integer NOT NULL CONSTRAINT check_duration CHECK (duration > 0),
    release_date date NOT NULL
);

DROP TABLE IF EXISTS MovieGenres CASCADE;

CREATE TABLE MovieGenres(
    movie_id integer NOT NULL REFERENCES Movies(id),
    genre_id integer NOT NULL REFERENCES Genres(id),
    PRIMARY KEY (movie_id, genre_id)
);

DROP TABLE IF EXISTS MovieStudios CASCADE;

CREATE TABLE MovieStudios(
    studio_id integer NOT NULL REFERENCES Studios(id),
    movie_id integer NOT NULL REFERENCES Movies(id),
    PRIMARY KEY (studio_id, movie_id)
);

DROP TABLE IF EXISTS People CASCADE;

CREATE TABLE People(
    id integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    birth_date date NOT NULL CONSTRAINT check_birth_date CHECK (birth_date <= CURRENT_DATE)
);

DROP TABLE IF EXISTS PeopleRoles CASCADE;

CREATE TABLE PeopleRoles(
    id integer PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS MovieCollaborators CASCADE;

CREATE TABLE MovieCollaborators(
    people_id integer NOT NULL REFERENCES People(id),
    movie_id integer NOT NULL REFERENCES Movies(id),
    role_id integer NOT NULL REFERENCES PeopleRoles(id),
    PRIMARY KEY (people_id, movie_id, role_id)
);

DROP TABLE IF EXISTS Screenings CASCADE;

CREATE TABLE Screenings(
    event_id integer NOT NULL REFERENCES Events(id),
    movie_id integer NOT NULL REFERENCES Movies(id),
    screening_time timestamp NOT NULL,
    PRIMARY KEY (event_id, movie_id)
);

-- Ratings and recommendations
DROP TABLE IF EXISTS UserEventRatings CASCADE;

CREATE TABLE UserEventRatings(
    user_id integer NOT NULL REFERENCES Users(id),
    event_id integer NOT NULL REFERENCES Events(id),
    rating integer NOT NULL CONSTRAINT check_rating CHECK (rating >= 0 AND rating <= 5),
    PRIMARY KEY (user_id, event_id)
);

DROP TABLE IF EXISTS UserMovieRatings CASCADE;

CREATE TABLE UserMovieRatings(
    user_id integer NOT NULL REFERENCES Users(id),
    movie_id integer NOT NULL REFERENCES Movies(id),
    rating integer NOT NULL CONSTRAINT check_rating CHECK (rating >= 0 AND rating <= 5),
    PRIMARY KEY (user_id, movie_id)
);

DROP TABLE IF EXISTS MovieRecommendation CASCADE;

CREATE TABLE MovieRecommendation(
    user_id integer NOT NULL REFERENCES Users(id),
    movie_id integer NOT NULL REFERENCES Movies(id),
    score_recommendation numeric NOT NULL,
    PRIMARY KEY (user_id, movie_id)
);

DROP TABLE IF EXISTS CompletedEventRecommendation CASCADE;

CREATE TABLE CompletedEventRecommendation(
    user_id integer NOT NULL REFERENCES Users(id),
    event_id integer NOT NULL REFERENCES Events(id),
    score_recommendation numeric NOT NULL,
    PRIMARY KEY (user_id, event_id)
);

DROP TABLE IF EXISTS ScheduledEventRecommendation CASCADE;

CREATE TABLE ScheduledEventRecommendation(
    user_id integer NOT NULL REFERENCES Users(id),
    event_id integer NOT NULL REFERENCES Events(id),
    score_recommendation numeric NOT NULL,
    PRIMARY KEY (user_id, event_id)
);

DROP TABLE IF EXISTS PostRecommendation CASCADE;

CREATE TABLE PostRecommendation(
    user_id integer NOT NULL REFERENCES Users(id),
    post_id integer NOT NULL REFERENCES Posts(id),
    score_recommendation numeric NOT NULL,
    PRIMARY KEY (user_id, post_id)
);

