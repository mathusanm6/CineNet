import pandas as pd
import pycountry
import numpy as np
from faker import Faker
import random
import os
import nltk
from nltk.corpus import stopwords

# Folder to store the generated CSV files
csv_dir = "CSV"

########################################################
############### Generate Data for Tables ###############
########################################################

# Install and download necessary NLTK resources
nltk.download("stopwords")
stop_words = set(stopwords.words("english"))

nltk.download("punkt")

# Initialize Faker to generate fake data
fake = Faker()

# Set seed for reproducibility
np.random.seed(0)
Faker.seed(0)

# Number of rows for each table
n_userroles = 5
n_users = 100
n_countries = 20
n_cities = 40
n_userlocations = n_users
n_followings = 300
n_friendships = 300
n_categories = 20
n_posts = 300
n_tags = 20
n_post_tags = 400
n_reactions = 600
n_movies = 200
n_events = 75
n_genres = 30
n_studios = 20
n_movie_studios = 50
n_people = 80
n_roles = 5
n_participations = 400
n_screenings = 300
n_user_event_ratings = n_users * n_events // 2
n_user_movie_ratings = n_users * n_movies // 2

########## Extract Data from MoviesDataset.csv ##########

# Define the path to the MoviesDataset.csv file
movies_dataset_path = "resources/MoviesDataset.csv"

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
movie_studios_dataset_path = "resources/MovieStudiosDataset.csv"

df_movie_studios = pd.read_csv(movie_studios_dataset_path)

unique_studios = df_movie_studios["name"].unique()

np.random.shuffle(unique_studios)

n_studios = min(len(unique_studios), n_studios)

studios = pd.DataFrame(
    {
        "id": range(1, n_studios + 1),
        "name": unique_studios[:n_studios],
    }
)


# Generate Tags
# Extract tags while filtering out stopwords and normalizing to lowercase
def extract_tags(text):
    return [
        word.lower()
        for word in nltk.word_tokenize(text)
        if word.isalpha() and word.lower() not in stop_words
    ]


title_tags = df_movies["Title"].apply(extract_tags).explode().unique()
genre_tags = (
    df_movies["Genre"]
    .apply(lambda x: extract_tags(x.replace(",", " ")))
    .explode()
    .unique()
)
description_tags = df_movies["Description"].apply(extract_tags).explode().unique()
director_tags = df_movies["Director"].apply(extract_tags).explode().unique()
actor_tags = (
    df_movies["Actors"]
    .apply(lambda x: extract_tags(x.replace(",", " ")))
    .explode()
    .unique()
)
studio_tags = studios["name"].unique()

# Drop NaN values
title_tags = title_tags[~pd.isnull(title_tags)]
genre_tags = genre_tags[~pd.isnull(genre_tags)]
description_tags = description_tags[~pd.isnull(description_tags)]
director_tags = director_tags[~pd.isnull(director_tags)]
actor_tags = actor_tags[~pd.isnull(actor_tags)]
studio_tags = studio_tags[~pd.isnull(studio_tags)]

# Combine all tags into a single set to ensure uniqueness
all_tags = (
    set(title_tags)
    | set(genre_tags)
    | set(description_tags)
    | set(director_tags)
    | set(actor_tags)
    | set(studio_tags)
)

# Create DataFrame
tags = pd.DataFrame({"name": list(all_tags)})
tags["id"] = range(1, len(tags) + 1)
tags = tags[["id", "name"]]

# Keep only the first n_tags tags
tags = tags.head(n_tags)

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

# Generate a list of randomly selected distinct countries
countries_data = [
    {"country_code": country.alpha_3, "name": country.name}
    for country in random.sample(list(pycountry.countries), n_countries)
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
userlocations = pd.DataFrame(
    {
        "user_id": users["id"],
        "city_code": np.random.choice(cities["city_code"], size=len(users)),
    }
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
while True:
    mask = friendship["initiator_id"] == friendship["recipient_id"]
    if not mask.any():
        break
    friendship.loc[mask, "recipient_id"] = np.random.choice(
        users["id"], size=mask.sum()
    )

# Ensure that there are no duplicate friendships
while True:
    mask = friendship.duplicated(subset=["initiator_id", "recipient_id"], keep=False)
    if not mask.any():
        break
    indices = friendship[mask].index
    friendship.loc[indices, "recipient_id"] = np.random.choice(
        users["id"], size=len(indices)
    )

# Ensure that there are no double friendships in both directions
while True:
    mask = friendship.apply(
        lambda row: any(
            (friendship["initiator_id"] == row["recipient_id"])
            & (friendship["recipient_id"] == row["initiator_id"])
        ),
        axis=1,
    )
    if not mask.any():
        break
    indices = friendship[mask].index
    friendship.loc[indices, "recipient_id"] = np.random.choice(
        users["id"], size=len(indices)
    )

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
        "name": [fake.word() for _ in range(n_categories)],
        "description": [fake.sentence() for _ in range(n_categories)],
    }
)

# Generate Posts
posts = pd.DataFrame(
    {
        "id": range(1, n_posts + 1),
        "user_id": np.random.choice(users["id"], n_posts),
        "date": [
            fake.date_time_between(start_date="-4y", end_date="now").isoformat()
            for _ in range(n_posts)
        ],
        "content": [fake.text() for _ in range(n_posts)],
        "parent_post_id": np.random.choice(
            [None] + list(range(1, n_posts + 1)), n_posts
        ),
        "category_id": np.random.choice(categories["id"], n_posts),
    }
)

# Generate Post-Tags Links
post_tags = pd.DataFrame(columns=["tag_id", "post_id"])

for post_id in posts["id"]:
    # Randomly decide how many tags this post will have (for example, 1 to 5 tags)
    n_tags_for_post = np.random.randint(1, 6)
    
    # Select that many unique tags randomly
    chosen_tags = np.random.choice(tags['id'], size=n_tags_for_post, replace=False)
    
    # Create a DataFrame of these combinations
    temp_df = pd.DataFrame({
        'post_id': post_id,
        'tag_id': chosen_tags
    })
    
    # Append to the main DataFrame
    post_tags = pd.concat([post_tags, temp_df], ignore_index=True)

# Generate Reactions
reactions = pd.DataFrame(
    {
        "user_id": np.random.choice(users["id"], n_reactions),
        "post_id": np.random.choice(posts["id"], n_reactions),
        "emoji": np.random.choice(["😄", "🙂", "😐", "🙁", "😩"], n_reactions),
    }
)

# Ensure that there are no duplicate reactions
while reactions.duplicated().any():
    duplicated_indices = reactions[reactions.duplicated()].index
    reactions.loc[duplicated_indices, "emoji"] = np.random.choice(
        ["😄", "🙂", "😐", "🙁", "😩"], size=len(duplicated_indices)
    )


# Ensure that users do not react to their own posts
while True:
    # Merge the posts DataFrame to the reactions DataFrame to include the user_id who created each post
    enriched_reactions = reactions.merge(
        posts[["id", "user_id"]],
        how="left",
        left_on="post_id",
        right_on="id",
        suffixes=("_reactor", "_poster"),
    )

    # Check for self-reactions
    mask = enriched_reactions["user_id_reactor"] == enriched_reactions["user_id_poster"]
    if not mask.any():
        break  # Exit loop if no self-reactions are found

    # For rows where a self-reaction is found, select a new post_id
    for idx in enriched_reactions[mask].index:
        user_id = enriched_reactions.loc[idx, "user_id_reactor"]

        # Select possible posts not made by the user
        possible_posts = posts[posts["user_id"] != user_id]["id"]

        # Randomly select a new post_id from the possible posts
        if not possible_posts.empty:
            new_post_id = np.random.choice(possible_posts)
            enriched_reactions.loc[idx, "post_id"] = new_post_id
        else:
            # Handle the case where no alternative posts are available
            enriched_reactions.drop(
                index=idx, inplace=True
            )  # Removing the reaction as a policy decision

    # Update the original reactions DataFrame
    reactions = enriched_reactions.drop(columns=["id", "user_id_poster"])
    reactions.rename(columns={"user_id_reactor": "user_id"}, inplace=True)


# Ensure that one user can react to a post only once
while reactions.duplicated(subset=["user_id", "post_id"]).any():
    duplicated_indices = reactions[reactions.duplicated(subset=["user_id", "post_id"])].index
    reactions.drop(index=duplicated_indices, inplace=True)


# Generate Events
events_dataset_path = "resources/EventsDataset.csv"

df_events = pd.read_csv(events_dataset_path)

unique_events = df_events["name"].unique()

np.random.shuffle(unique_events)

n_events = min(len(unique_events), n_events)

events = pd.DataFrame(
    {
        "id": range(1, n_events + 1),
        "name": unique_events[:n_events],
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
        # Only select events that are scheduled
        "event_id": np.random.choice(
            events[events["status"] == "Scheduled"]["id"], n_participations
        ),
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
################ Modify Data for Tables ################
########################################################

# Choose users
user_posting_id = 27
users_sample = users[users["id"] != user_posting_id].sample(7)

# Users from user_sample reacts to every single post of user_posting_id
reactions_user1 = pd.DataFrame(columns=["user_id", "post_id", "emoji"])

for post_id in posts[posts["user_id"] == user_posting_id]["id"]:
    for user_id in users_sample["id"]:
        reactions_user1 = pd.concat(
            [
                reactions_user1,
                pd.DataFrame(
                    {
                        "user_id": [user_id],
                        "post_id": [post_id],
                        "emoji": np.random.choice(["😄", "🙂", "😐", "🙁", "😩"]),
                    }
                ),
            ],
            ignore_index=True,
        )

# Concatenate the reactions of user1 to reactions DataFrame
reactions = pd.concat([reactions, reactions_user1], ignore_index=True)

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
