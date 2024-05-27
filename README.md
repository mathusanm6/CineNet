# CineNet

A social forum for cinema fans, based on a database, using PostgreSQL for data processing and interactive SQL queries for personalized content and recommendations.

### Table of Contents:

1. [Own Contributions to CineNet](#own-contributions-to-cinenet)
   - [Database Design and Creation](#database-design-and-creation)
   - [Data Generation and Import](#data-generation-and-import)
   - [Interactive Querying](#interactive-querying)
   - [Recommendation System](#recommendation-system)
2. [Visuals](#visuals)
   - [ER Diagram](#er-diagram)
   - [Report](#report)
   - [Screenshots](#screenshots)
3. [Installation](#installation)
4. [Usage](#usage)
   - [Usage Examples](#usage-examples)

### Own Contributions to CineNet

#### Database Design and Creation

- **ER Diagram**: Created the Entity-Relationship (ER) diagram for the CineNet database.
- **Database Creation**: Developed the database schema and created tables using SQL.

#### Data Generation and Import

- **Generate CSV Files**: Wrote a Python script to generate CSV files with interesting data for the database (using Faker library).
- **Import Data**: Developed a SQL script to import data from CSV files into the database.

#### Interactive Querying

- **Interactive Queries Script**:
  - Created an interactive SQL query script to allow users to query the database.
  - Enhanced user experience by adding a help page and error handling.
  - Organized scripts using Bash to streamline execution.
- **16 Interactive Queries**: Implemented 16 diverse and complex queries to showcase the capabilities of the database. Examples include:
  - Listing all users participating in a given scheduled event.
  - Listing all users following a specific user.
  - Listing all users with a minimum number of followers.
  - Calculating the average number of followers per user per country.
  - Listing all users who posted after a certain date.
  - Counting the number of users per country.
  - Counting the number of posts per tag with a specific emoji reaction.
  - Calculating the average maximum number of reactions per post.
  - Listing all users with a specific type of participation in events with a given status.
  - Get the next scheduled event.
  - Listing the top 10 events with the most participants in a given year.

#### Recommendation System

- **Recommendation System**:
  - Developed recommendation systems for movies, events, and posts.
  - Calculated the cosine similarity between movies and users to recommend movies, for example.

### Visuals

#### ER Diagram

<div align="center">
    <img src="./er-diagram-cinenet/erd.png" alt="ER Diagram" width="100%">
</div>

The [ER Diagram](./er-diagram-cinenet/erd.pdf) for the CineNet database is available in the `er-diagram-cinenet` directory. The diagram was created using Lucidchart and exported as a PDF file.

##### Errors on the ER Diagram

- The `Genre` table should not include a release date attribute, contrary to what is indicated on the diagram.
- The `Person` table should only contain the full name of the person, without distinction of first name, last name, etc.
- Several tables related to recommendations are not included in the ER diagram, as they are dynamically generated or were added after the initial design.

#### Report

The report for this project is available in French at [CineNet-Rapport](https://github.com/mathusanm6/CineNet-Rapport) github repository.

#### Screenshots

<table align="center" style="width:1200px; table-layout: fixed;">
  <tr>
    <td colspan="4">
      <figure>
        <img src="images/help.jpeg" alt="Help" width="100%"/>
        <figcaption align="center">Help Page</figcaption>
      </figure>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <figure>
        <img src="images/interactive-page1.jpeg" alt="Interactive Queries Page" width="100%"/>
        <figcaption align="center">Interactive Queries Page</figcaption>
      </figure>
    </td>
    <td colspan="2">
      <figure>
        <img src="images/follower-search-tool.jpeg" alt="Follower Search Tool" width="100%"/>
        <figcaption align="center">Follower Search Tool</figcaption>
      </figure>
    </td>
  </tr>
  <tr><td colspan="4" style="height: 30px;"></td></tr> <!-- Spacer Row -->
  <tr>
    <td colspan="4">
      <figure>
        <img src="images/follower-search-tool-results.jpeg" alt="Follower Search Tool Result" width="100%"/>
        <figcaption align="center">Follower Search Tool Result</figcaption>
      </figure>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <figure>
        <img src="images/top-10-popular-events.jpeg" alt="Top 10 Popular Events" width="100%"/>
        <figcaption align="center">Top 10 Popular Events</figcaption>
      </figure>
    </td>
    <td colspan="2">
      <figure>
        <img src="images/movies-recommendation.jpeg" alt="Movies Recommendation" width="100%"/>
        <figcaption align="center">Movies Recommendation</figcaption>
      </figure>
    </td>
  </tr>
  <tr>
    <td colspan="4">
      <figure>
        <img src="images/movie-recommendation-results.jpeg" alt="Movie Recommendation Results" width="100%"/>
        <figcaption align="center">Movie Recommendation Results</figcaption>
      </figure>
    </td>
  </tr>
</table>

### Installation

1. Clone the Git repository to your local machine:

```bash
$ git clone git@github.com:mathusanm6/CineNet.git
```

2. Ensure you have PostgreSQL installed on your machine.

3. Ensure you have Python 3 installed on your machine.

4. Install the required Python dependencies by running the following commands at the root of the project:

```bash
$ python3 -m venv ./cinenet_env
$ source ./cinenet_env/bin/activate
$ python3 -m pip install -r requirements.txt
```

5. Ensure you have execution rights for the `run.sh` bash script by running the following command at the root of the project:

```bash
$ chmod +x ./run.sh
```

### Usage

To use the CineNet program, run the `run.sh` bash script at the root of the project with the options and an additional argument to control the display of output details. Here are the options you can specify:

- **1**: To only run the `create_db.sh` script, which creates the database.
- **2**: To only run the `generate_csv.py` script, which generates CSV files from interesting data.
- **3**: To only run the `import_data.sh` script, which imports data from CSV files into the database.
- **4**: To only run the `init_recommendation.sh` script, which initializes the recommendation system.
- **all**: To run all scripts in order: `create_db.sh`, `generate_csv.py`, and finally `import_data.sh`.
- **interactive**: To start an interactive SQL query session on the database.

Each command except `interactive` takes an additional argument to control the display of output details. The options are:

- **yes**: To display PostgreSQL output details.
- **no**: To not display PostgreSQL output details.

#### Usage Examples

```bash
$ ./run.sh 1 yes  # Only creates the database and displays PostgreSQL outputs
$ ./run.sh 2 no   # Only runs generate_csv.py without displaying PostgreSQL outputs
$ ./run.sh 3 yes  # Only runs import_data.sh and displays PostgreSQL outputs
$ ./run.sh 4 no   # Only starts init_recommendation.sh without displaying PostgreSQL outputs
$ ./run.sh all yes  # Runs all scripts except init_recommendation.sh in sequence and displays PostgreSQL outputs
$ ./run.sh interactive  # Starts an interactive SQL query session
```
