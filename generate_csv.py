import pandas as pd
import pycountry
import numpy as np
from faker import Faker
import os

# Folder to store the generated CSV files
csv_dir = "CSV"

########################################################
############### Generate Data for Tables ###############
########################################################

# Initialize Faker to generate fake data
fake = Faker()

# Set seed for reproducibility
np.random.seed(0)

# Number of rows for each table
n_userroles = 5
n_users = 150
n_countries = 10
n_cities = 20
n_userlocations = 50
n_followings = 200
n_friendships = 200
n_categories = 10
n_posts = 200
n_tags = 30
n_post_tags = 400
n_reactions = 500
n_movies = 100
n_events = 50
n_genres = 20
n_studios = 15
n_movie_studios = 50
n_people = 80
n_roles = 5
n_participations = 300
n_screenings = 150
n_user_event_ratings = n_users * n_events // 2
n_user_movie_ratings = n_users * n_movies // 2

########## Extract Data from MoviesDataset.csv ##########

# Define the path to the MoviesDataset.csv file
movies_dataset_path = "MoviesDataset.csv"

# Load the MoviesDataset.csv file
df_movies = pd.read_csv(movies_dataset_path)
df_movies.columns = [
    "Rank",
    "Title",
    "Genre",
    "Description",
    "Director",
    "Actors",
    "Year",
    "Runtime (Minutes)",
    "Rating",
    "Votes",
    "Revenue (Millions)",
    "Metascore",
]

# Extract movie data
movies = df_movies[["Title", "Year", "Runtime (Minutes)"]].copy()
movies.columns = ["title", "release_date", "duration"]
movies["id"] = range(1, len(movies) + 1)
movies["release_date"] = pd.to_datetime(movies["release_date"], format="%Y")
movies = movies[["id", "title", "duration", "release_date"]]

# Extract genre data
genres = pd.DataFrame({"name": df_movies["Genre"].str.split(",").explode().unique()})
genres["id"] = range(1, len(genres) + 1)
genres = genres[["id", "name"]]
genres["parent_genre_id"] = np.random.choice([None] + list(genres["id"]), len(genres))

# Create movie-genre links
movie_genres = df_movies["Genre"].str.split(",").explode().reset_index()
movie_genres["genre_id"] = movie_genres["Genre"].map(genres.set_index("name")["id"])
movie_genres["movie_id"] = (
    movie_genres["index"] + 1
)  # Adjust this to align with movie IDs
movie_genres = movie_genres[["movie_id", "genre_id"]]
movie_genres.drop_duplicates(inplace=True)

# Drop the movie-genre rows if movie_id is not in the movies DataFrame
movie_genres = movie_genres[movie_genres["movie_id"].isin(movies["id"])]

# Extract people data
# Extract actors
actors = pd.DataFrame({"name": df_movies["Actors"].str.split(",").explode().unique()})
actors["id"] = range(1001, 1001 + len(actors))

# Extract directors
directors = pd.DataFrame({"name": df_movies["Director"].unique()})
directors["id"] = range(1, len(directors) + 1)

# Add actors and directors to the people DataFrame
people = pd.concat([directors, actors], ignore_index=True)

# Split name into first_name and last_name
people["date_of_birth"] = fake.date_of_birth(minimum_age=18, maximum_age=70).isoformat()
people = people[["id", "name", "date_of_birth"]]

# Create people-roles links
people_roles = pd.DataFrame({"id": [1, 2], "name": ["Director", "Actor"]})

# Create movie-collaborators DataFrame
movie_collaborators = pd.DataFrame(columns=["people_id", "movie_id", "role_id"])

# Remove rows where movie_id is not in the movies DataFrame
movie_collaborators = movie_collaborators[
    movie_collaborators["movie_id"].isin(movies["id"])
]

for i, row in df_movies.iterrows():
    movie_id = i + 1
    director_ids = people[people["name"] == row["Director"]]["id"].values
    if director_ids.size > 0:
        director_id = director_ids[0]
        director_df = pd.DataFrame(
            [{"people_id": director_id, "movie_id": movie_id, "role_id": 1}]
        )
        movie_collaborators = pd.concat(
            [movie_collaborators, director_df], ignore_index=True
        )

    for actor in row["Actors"].split(", "):
        actor_ids = people[people["name"] == actor]["id"].values
        if actor_ids.size > 0:
            actor_id = actor_ids[0]
            actor_df = pd.DataFrame(
                [{"people_id": actor_id, "movie_id": movie_id, "role_id": 2}]
            )
            movie_collaborators = pd.concat(
                [movie_collaborators, actor_df], ignore_index=True
            )

# Generate Studios
studios = pd.DataFrame(
    {
        "id": range(1, n_studios + 1),
        "name": [fake.company() for _ in range(n_studios)],
    }
)

################ Generate Data for Tables ###############

# Generate UserRoles
userroles = pd.DataFrame(
    {
        "type": range(1, n_userroles + 1),
        "name": ["Person", "Studio", "Festival_org", "Club_org", "Cinema_org"],
        "description": [fake.sentence() for _ in range(n_userroles)],
    }
)

# Generate Users
users = pd.DataFrame(
    {
        "id": range(1, n_users + 1),
        "last_name": [fake.last_name() for _ in range(n_users)],
        "first_name": [fake.first_name() for _ in range(n_users)],
        "username": [fake.user_name() for _ in range(n_users)],
        "email": [fake.email() for _ in range(n_users)],
        "password": [fake.password() for _ in range(n_users)],
        "birth_date": [
            fake.date_of_birth(minimum_age=18, maximum_age=70).isoformat()
            for _ in range(n_users)
        ],
        "role_type": np.random.choice(userroles["type"], n_users),
    }
)

# Ensure that there are no duplicate usernames
mask = users["username"].duplicated()
while mask.any():
    users.loc[mask, "username"] = [fake.user_name() for _ in range(mask.sum())]
    mask = users["username"].duplicated()

# Ensure that there are no duplicate emails
mask = users["email"].duplicated()
while mask.any():
    users.loc[mask, "email"] = [fake.email() for _ in range(mask.sum())]
    mask = users["email"].duplicated()

# Generate Countries
countries_data = [
    {"country_code": country.alpha_3, "name": country.name}
    for country in list(pycountry.countries)[:n_countries]
]

countries = pd.DataFrame(countries_data)

# Generate Cities and link with Countries
cities = pd.DataFrame(
    {
        "city_code": range(1, n_cities + 1),
        "name": [fake.city() for _ in range(n_cities)],
        "country_code": np.random.choice(countries["country_code"], n_cities),
    }
)

# Generate UserLocations
if n_userlocations > len(users) * len(cities):
    raise ValueError("Requested more user locations than possible unique pairs.")

userlocations = (
    pd.DataFrame(
        {
            "user_id": np.repeat(users["id"], len(cities)),
            "city_code": np.tile(cities["city_code"], len(users)),
        }
    )
    .sample(n_userlocations)
    .reset_index(drop=True)
)

# Generate Friendships Followings
friendship = pd.DataFrame(
    {
        "initiator_id": np.random.choice(users["id"], n_friendships),
        "recipient_id": np.random.choice(users["id"], n_friendships),
        "date": [
            fake.date_time_this_year().isoformat(sep=" ") for _ in range(n_friendships)
        ],
    }
)

# Ensure that the initiator is not the same as the recipient

mask = friendship["initiator_id"] == friendship["recipient_id"]
while mask.any():
    friendship.loc[mask, "recipient_id"] = np.random.choice(
        users["id"], size=mask.sum()
    )
    mask = friendship["initiator_id"] == friendship["recipient_id"]

# Ensure that there are no duplicate friendships
mask = friendship[["initiator_id", "recipient_id"]].duplicated()
while mask.any():
    friendship.loc[mask, "recipient_id"] = np.random.choice(
        users["id"], size=mask.sum()
    )
    mask = friendship[["initiator_id", "recipient_id"]].duplicated()

# Generate Followings
following = pd.DataFrame(
    {
        "follower_id": np.random.choice(users["id"], n_followings),
        "followed_id": np.random.choice(users["id"], n_followings),
        "date": [
            fake.date_time_this_year().isoformat(sep=" ") for _ in range(n_followings)
        ],
    }
)

# Ensure that there are no self-followings
mask = following["follower_id"] == following["followed_id"]
while mask.any():
    following.loc[mask, "followed_id"] = np.random.choice(users["id"], size=mask.sum())
    mask = following["follower_id"] == following["followed_id"]

# Ensure that there are no duplicate followings
mask = following[["follower_id", "followed_id"]].duplicated()
while mask.any():
    following.loc[mask, "followed_id"] = np.random.choice(users["id"], size=mask.sum())
    mask = following[["follower_id", "followed_id"]].duplicated()

# Generate Categories for Posts
categories = pd.DataFrame(
    {
        "id": range(1, n_categories + 1),
        "name": [fake.word() + " category" for _ in range(n_categories)],
        "description": [fake.sentence() for _ in range(n_categories)],
    }
)

# Generate Posts
posts = pd.DataFrame(
    {
        "id": range(1, n_posts + 1),
        "user_id": np.random.choice(users["id"], n_posts),
        "date": [fake.date_time_this_year().isoformat(sep=" ") for _ in range(n_posts)],
        "content": [fake.text() for _ in range(n_posts)],
        "parent_post_id": np.random.choice(
            [None] + list(range(1, n_posts + 1)), n_posts
        ),
        "category_id": np.random.choice(categories["id"], n_posts),
    }
)

# Generate Tags
tags = pd.DataFrame(
    {
        "id": range(1, n_tags + 1),
        "name": [fake.word() + " tag" for _ in range(n_tags)],
    }
)

# Generate Post-Tags Links
post_tags = pd.DataFrame(
    {
        "tag_id": np.random.choice(tags["id"], n_post_tags),
        "post_id": np.random.choice(posts["id"], n_post_tags),
    }
)

# Ensure that there are no duplicate post-tag links
mask = post_tags.duplicated()
while mask.any():
    post_tags.loc[mask, "tag_id"] = np.random.choice(tags["id"], size=mask.sum())
    post_tags.loc[mask, "post_id"] = np.random.choice(posts["id"], size=mask.sum())
    mask = post_tags.duplicated()

# Generate Reactions
reactions = pd.DataFrame(
    {
        "user_id": np.random.choice(users["id"], n_reactions),
        "post_id": np.random.choice(posts["id"], n_reactions),
        "emoji": np.random.choice(["😀", "😢", "👍", "👎", "❤️"], n_reactions),
    }
)

# Ensure that there are no duplicate reactions
mask = reactions.duplicated()
while mask.any():
    reactions.loc[mask, "user_id"] = np.random.choice(users["id"], size=mask.sum())
    reactions.loc[mask, "post_id"] = np.random.choice(posts["id"], size=mask.sum())
    mask = reactions.duplicated()

# Generate Events
events = pd.DataFrame(
    {
        "id": range(1, n_events + 1),
        "name": [
            np.random.choice(
                ["Event", "Festival", "Screening", "Concert", "Exhibition"]
            )
            + " "
            + fake.word()
            for _ in range(n_events)
        ],
        "date": [
            fake.future_date(end_date="+30d").isoformat() + "T" + fake.time()
            for _ in range(n_events)
        ],
        "city_code": np.random.choice(cities["city_code"], n_events),
        "organizer_id": np.random.choice(users["id"], n_events),
        "capacity": np.random.randint(50, 501, n_events),
        "ticket_price": np.random.uniform(10, 100, n_events).round(2),
        "status": np.random.choice(["Scheduled", "Completed", "Cancelled"], n_events),
    }
)

# Generate Participation in Events for Users with role_type = 1 (Person)
participation = pd.DataFrame(
    {
        "user_id": np.random.choice(
            users[users["role_type"] == 1]["id"], n_participations
        ),
        "event_id": np.random.choice(events["id"], n_participations),
        "type_participation": np.random.choice(
            ["Interested", "Participating"], n_participations
        ),
    }
)

# Ensure that there are no duplicate participations (user_id, event_id pairs) as primary key
mask = participation.duplicated(subset=["user_id", "event_id"])
while mask.any():
    participation.loc[mask, "user_id"] = np.random.choice(
        users[users["role_type"] == 1]["id"], size=mask.sum()
    )
    participation.loc[mask, "event_id"] = np.random.choice(
        events["id"], size=mask.sum()
    )
    mask = participation.duplicated(subset=["user_id", "event_id"])

# Generate Movie-Studios Links
movie_studios = pd.DataFrame(
    {
        "movie_id": np.random.choice(movies["id"], n_movie_studios),
        "studio_id": np.random.choice(studios["id"], n_movie_studios),
    }
)

# Ensure that there are no duplicate movie-studio links
mask = movie_studios.duplicated()
while mask.any():
    movie_studios.loc[mask, "movie_id"] = np.random.choice(
        movies["id"], size=mask.sum()
    )
    movie_studios.loc[mask, "studio_id"] = np.random.choice(
        studios["id"], size=mask.sum()
    )
    mask = movie_studios.duplicated()

# Ensure that there are no duplicate movie-collaborator links
mask = movie_collaborators.duplicated()
while mask.any():
    movie_collaborators.loc[mask, "people_id"] = np.random.choice(
        people["id"], size=mask.sum()
    )
    movie_collaborators.loc[mask, "movie_id"] = np.random.choice(
        movies["id"], size=mask.sum()
    )
    movie_collaborators.loc[mask, "role_id"] = np.random.choice(
        people_roles["id"], size=mask.sum()
    )
    mask = movie_collaborators.duplicated()

# Generate Screenings
screenings = pd.DataFrame(
    {
        "event_id": np.random.choice(events["id"], n_screenings),
        "movie_id": np.random.choice(movies["id"], n_screenings),
        "screening_time": [
            fake.date_time_this_year().isoformat(sep=" ") for _ in range(n_screenings)
        ],
    }
)

# Ensure that there are no duplicate screenings (event_id, movie_id pairs) as primary key
mask = screenings.duplicated(subset=["event_id", "movie_id"])
while mask.any():
    screenings.loc[mask, "event_id"] = np.random.choice(events["id"], size=mask.sum())
    screenings.loc[mask, "movie_id"] = np.random.choice(movies["id"], size=mask.sum())
    mask = screenings.duplicated(subset=["event_id", "movie_id"])

# Generate User Ratings for Events
user_event_ratings = pd.DataFrame(
    {
        "user_id": np.random.choice(users["id"], n_user_event_ratings),
        "event_id": np.random.choice(events["id"], n_user_event_ratings),
        "rating": np.random.randint(
            1, 6, n_user_event_ratings
        ),  # Ratings between 1 and 5
    }
)

# Ensure that there are no duplicate user-event ratings (user_id, event_id pairs) as primary key
mask = user_event_ratings.duplicated(subset=["user_id", "event_id"])
while mask.any():
    user_event_ratings.loc[mask, "user_id"] = np.random.choice(
        users["id"], size=mask.sum()
    )
    user_event_ratings.loc[mask, "event_id"] = np.random.choice(
        events["id"], size=mask.sum()
    )
    mask = user_event_ratings.duplicated(subset=["user_id", "event_id"])

# Generate User Ratings for Movies
user_movie_ratings = pd.DataFrame(
    {
        "user_id": np.random.choice(users["id"], n_user_movie_ratings),
        "movie_id": np.random.choice(movies["id"], n_user_movie_ratings),
        "rating": np.random.randint(
            1, 6, n_user_movie_ratings
        ),  # Ratings between 1 and 5
    }
)

# Ensure that there are no duplicate user-movie ratings (user_id, movie_id pairs) as primary key
mask = user_movie_ratings.duplicated(subset=["user_id", "movie_id"])
while mask.any():
    user_movie_ratings.loc[mask, "user_id"] = np.random.choice(
        users["id"], size=mask.sum()
    )
    user_movie_ratings.loc[mask, "movie_id"] = np.random.choice(
        movies["id"], size=mask.sum()
    )
    mask = user_movie_ratings.duplicated(subset=["user_id", "movie_id"])

########################################################
################ Save Data to CSV Files ################
########################################################

# If CSV folder does not exist, create it
if not os.path.exists(csv_dir):
    os.makedirs(csv_dir)

# DataFrames to be saved
dataframes = {
    "userroles": userroles,
    "users": users,
    "countries": countries,
    "cities": cities,
    "userlocations": userlocations,
    "friendship": friendship,
    "following": following,
    "categories": categories,
    "posts": posts,
    "tags": tags,
    "posttags": post_tags,
    "reactions": reactions,
    "events": events,
    "participation": participation,
    "genres": genres,
    "studios": studios,
    "movies": movies,
    "moviegenres": movie_genres,
    "moviestudios": movie_studios,
    "people": people,
    "peopleroles": people_roles,
    "moviecollaborators": movie_collaborators,
    "screenings": screenings,
    "usereventratings": user_event_ratings,
    "usermovieratings": user_movie_ratings,
}

# Save all DataFrames to CSV files
for name, df in dataframes.items():
    df.to_csv(os.path.join(csv_dir, f"{name}.csv"), index=False)

print("CSV files have been generated and are ready to be used!")
