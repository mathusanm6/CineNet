# CineNet

Forum social pour les fans de cinéma, basé sur une base de données, utilisant PostgreSQL pour le traitement des données et des requêtes SQL interactives pour un contenu personnalisé et des recommandations.

### Utilisation

#### Pour générer les fichiers CSV, exécutez les commandes suivantes :

```bash
python3 generate_csv.py
```

#### Pour initialiser la base de données, exécutez les commandes suivantes :

```bash
chmod +x init_db.sh
./init_db.sh
```

#### Pour préparer les recommandations, exécutez les commandes suivantes après avoir inséré des données dans les tables :

```bash
chmod +x init_recommendation.sh
./init_recommendation.sh
```

### Erreurs sur le diagramme ER

- La table `Genre` ne devrait pas avoir d'attribut de date de sortie (mauvaise indication sur le diagramme)
- La table `Person` ne contient uniquement le nom entier de la personne (pas de prénom, nom de famille, etc.)
