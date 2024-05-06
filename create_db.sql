-- For ease of use, this creates a schema
CREATE SCHEMA IF NOT EXISTS cine_net;

set
    search_path to cine_net;

-- Users and their roles
DROP TABLE IF EXISTS UserRoles CASCADE;

CREATE TABLE
    UserRoles (
        type INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT
    );

DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE
    Users (
        id INTEGER PRIMARY KEY,
        last_name VARCHAR(255) NOT NULL,
        first_name VARCHAR(255) NOT NULL,
        username VARCHAR(255) UNIQUE NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        birth_date DATE,
        role_type INTEGER NOT NULL REFERENCES UserRoles (type)
    );

-- Locations
DROP TABLE IF EXISTS Countries CASCADE;

CREATE TABLE
    Countries (
        country_code CHAR(3) PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

DROP TABLE IF EXISTS Cities CASCADE;

CREATE TABLE
    Cities (
        city_code INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        country_code CHAR(3) NOT NULL REFERENCES Countries (country_code)
    );

DROP TABLE IF EXISTS UserLocations CASCADE;

CREATE TABLE
    UserLocations (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        city_code INTEGER NOT NULL REFERENCES Cities (city_code),
        PRIMARY KEY (user_id, city_code)
    );

-- Social interactions
DROP TABLE IF EXISTS Friendship CASCADE;

CREATE TABLE
    Friendship (
        initiator_id INTEGER NOT NULL REFERENCES Users (id),
        recipient_id INTEGER NOT NULL REFERENCES Users (id),
        date TIMESTAMP NOT NULL,
        PRIMARY KEY (initiator_id, recipient_id)
    );

DROP TABLE IF EXISTS Following CASCADE;

CREATE TABLE
    Following (
        follower_id INTEGER NOT NULL REFERENCES Users (id),
        followed_id INTEGER NOT NULL REFERENCES Users (id),
        date TIMESTAMP NOT NULL,
        PRIMARY KEY (follower_id, followed_id)
    );

-- Posts and social media interactions
DROP TABLE IF EXISTS Categories CASCADE;

CREATE TABLE
    Categories (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT
    );

DROP TABLE IF EXISTS Posts CASCADE;

CREATE TABLE
    Posts (
        id INTEGER PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES Users (id),
        date TIMESTAMP NOT NULL,
        content TEXT NOT NULL,
        parent_post_id INTEGER REFERENCES Posts (id),
        category_id INTEGER NOT NULL REFERENCES Categories (id)
    );

DROP TABLE IF EXISTS Tags CASCADE;

CREATE TABLE
    Tags (id INTEGER PRIMARY KEY, name VARCHAR(255) NOT NULL);

DROP TABLE IF EXISTS PostTags CASCADE;

CREATE TABLE
    PostTags (
        tag_id INTEGER NOT NULL REFERENCES Tags (id),
        post_id INTEGER NOT NULL REFERENCES Posts (id),
        PRIMARY KEY (tag_id, post_id)
    );

DROP TABLE IF EXISTS Reactions CASCADE;

-- Reactions : 
-- Excellent -> "😄", 
-- Good -> "🙂", 
-- Average -> "😐,  
-- "Poor -> "🙁", 
-- Terrible -> "😩"

CREATE TABLE
    Reactions (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        post_id INTEGER NOT NULL REFERENCES Posts (id),
        emoji VARCHAR(10) NOT NULL,
        PRIMARY KEY (user_id, post_id, emoji)
    );

-- Events and related entities
DROP TABLE IF EXISTS Events CASCADE;

CREATE TABLE
    Events (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        date TIMESTAMP NOT NULL,
        city_code INTEGER NOT NULL REFERENCES Cities (city_code),
        organizer_id INTEGER NOT NULL REFERENCES Users (id),
        capacity INTEGER NOT NULL,
        ticket_price NUMERIC NOT NULL
    );

-- Enabling different event types (Scheduled, Completed, Cancelled)
ALTER TABLE Events
ADD COLUMN status VARCHAR(255) NOT NULL;

DROP TABLE IF EXISTS Participation CASCADE;

CREATE TABLE
    Participation (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        event_id INTEGER NOT NULL REFERENCES Events (id),
        type_participation VARCHAR(255) NOT NULL,
        PRIMARY KEY (user_id, event_id)
    );

-- Movies, genres, and collaborators
DROP TABLE IF EXISTS Genres CASCADE;

CREATE TABLE
    Genres (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        parent_genre_id INTEGER REFERENCES Genres (id)
    );

DROP TABLE IF EXISTS Studios CASCADE;

CREATE TABLE
    Studios (id INTEGER PRIMARY KEY, name VARCHAR(255) NOT NULL);

DROP TABLE IF EXISTS Movies CASCADE;

CREATE TABLE
    Movies (
        id INTEGER PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        duration INTEGER NOT NULL,
        release_date DATE NOT NULL
    );

DROP TABLE IF EXISTS MovieGenres CASCADE;

CREATE TABLE
    MovieGenres (
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        genre_id INTEGER NOT NULL REFERENCES Genres (id),
        PRIMARY KEY (movie_id, genre_id)
    );

DROP TABLE IF EXISTS MovieStudios CASCADE;

CREATE TABLE
    MovieStudios (
        studio_id INTEGER NOT NULL REFERENCES Studios (id),
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        PRIMARY KEY (studio_id, movie_id)
    );

DROP TABLE IF EXISTS People CASCADE;

CREATE TABLE
    People (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        birth_date DATE NOT NULL
    );

DROP TABLE IF EXISTS PeopleRoles CASCADE;

CREATE TABLE
    PeopleRoles (id INTEGER PRIMARY KEY, name VARCHAR(255));

DROP TABLE IF EXISTS MovieCollaborators CASCADE;

CREATE TABLE
    MovieCollaborators (
        people_id INTEGER NOT NULL REFERENCES People (id),
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        role_id INTEGER NOT NULL REFERENCES PeopleRoles (id),
        PRIMARY KEY (people_id, movie_id, role_id)
    );

DROP TABLE IF EXISTS Screenings CASCADE;

CREATE TABLE
    Screenings (
        event_id INTEGER NOT NULL REFERENCES Events (id),
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        screening_time TIMESTAMP NOT NULL,
        PRIMARY KEY (event_id, movie_id)
    );

-- Ratings and recommendations
DROP TABLE IF EXISTS UserEventRatings CASCADE;

CREATE TABLE
    UserEventRatings (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        event_id INTEGER NOT NULL REFERENCES Events (id),
        rating INTEGER NOT NULL,
        PRIMARY KEY (user_id, event_id)
    );

DROP TABLE IF EXISTS UserMovieRatings CASCADE;

CREATE TABLE
    UserMovieRatings (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        rating INTEGER NOT NULL,
        PRIMARY KEY (user_id, movie_id)
    );

DROP TABLE IF EXISTS MovieRecommendation CASCADE;

CREATE TABLE
    MovieRecommendation (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        movie_id INTEGER NOT NULL REFERENCES Movies (id),
        score_recommendation NUMERIC NOT NULL,
        PRIMARY KEY (user_id, movie_id)
    );

DROP TABLE IF EXISTS CompletedEventRecommendation CASCADE;

CREATE TABLE
    CompletedEventRecommendation (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        event_id INTEGER NOT NULL REFERENCES Events (id),
        score_recommendation NUMERIC NOT NULL,
        PRIMARY KEY (user_id, event_id)
    );

DROP TABLE IF EXISTS ScheduledEventRecommendation CASCADE;

CREATE TABLE
    ScheduledEventRecommendation (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        event_id INTEGER NOT NULL REFERENCES Events (id),
        score_recommendation NUMERIC NOT NULL,
        PRIMARY KEY (user_id, event_id)
    );

DROP TABLE IF EXISTS PostRecommendation CASCADE;

CREATE TABLE
    PostRecommendation (
        user_id INTEGER NOT NULL REFERENCES Users (id),
        post_id INTEGER NOT NULL REFERENCES Posts (id),
        score_recommendation NUMERIC NOT NULL,
        PRIMARY KEY (user_id, post_id)
    );