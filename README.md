# CineNet
Forum social pour les fans de cinéma, basé sur une base de données, utilisant PostgreSQL pour le traitement des données et des requêtes SQL interactives pour un contenu personnalisé et des recommandations.

### Utilisation
Pour générer les fichiers csv, exécutez les commandes suivantes :

```bash
python3 generate_csv.py
```

Après avoir accédé au shell postgres, exécutez les commandes suivantes pour créer la base de données et les tables ainsi que pour insérer les données dans les tables à partir des fichiers csv:

```sql
\i init_db.sql
```

#### Pour les recommandations, exécutez les commandes suivantes après avoir inséré des données dans les tables :

```sql
\i movie_recommendation.sql
\i event_recommendation.sql
\i post_recommendation.sql
```

### Erreurs sur le diagramme ER
- La table `Genre` ne devrait pas avoir d'attribut de date de sortie (mauvaise indication sur le diagramme)
- La table `Person` ne contient uniquement le nom entier de la personne (pas de prénom, nom de famille, etc.)