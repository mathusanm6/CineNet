# CineNet
Database-driven social forum for movie fans, featuring PostgreSQL for data handling and interactive SQL queries for personalised content and recommendations.

### Utilisation
After getting to the postgres shell, run the following commands to create the database and the tables:

```sql
\i prepare_db.sql
```

### Errors on the ERD
- The `Genre` table Shouldn't have a release date attribute.