# CineNet

Forum social pour les fans de cinéma, basé sur une base de données, utilisant PostgreSQL pour le traitement des données et des requêtes SQL interactives pour un contenu personnalisé et des recommandations.

### Utilisation :

Pour utiliser le programme CineNet, lancez le script bash `run.sh` à la racine du projet avec les options et un argument supplémentaire pour contrôler l'affichage des détails de sortie. Voici les options que vous pouvez spécifier :

- **1** : Pour exécuter uniquement le script `create_db.sh`, qui crée la base de données.
- **2** : Pour exécuter uniquement le script `generate_csv.py`, qui génère des fichiers CSV à partir des données intéressantes.
- **3** : Pour exécuter uniquement le script `import_data.sh`, qui importe les données depuis les fichiers CSV dans la base de données.
- **4** : Pour exécuter uniquement le script `init_recommendation.sh`, qui initialise le système de recommandation.
- **all** : Pour exécuter tous les scripts dans l'ordre : `create_db.sh`, `generate_csv.py`, `import_data.sh`, et enfin `init_recommendation.sh`.

Chaque commande peut être suivie de `yes` pour afficher les sorties de la base de données PostgreSQL, ou `no` pour ne pas les afficher.

#### Exemples d'utilisation :

```bash
$ ./run.sh 1 yes  # Crée uniquement la base de données et affiche les sorties de PostgreSQL
$ ./run.sh 2 no   # Exécute uniquement generate_csv.py sans afficher les sorties de PostgreSQL
$ ./run.sh 3 yes  # Exécute seulement import_data.sh et affiche les sorties de PostgreSQL
$ ./run.sh 4 no   # Démarre uniquement init_recommendation.sh sans afficher les sorties de PostgreSQL
$ ./run.sh all yes  # Exécute tous les scripts en séquence et affiche les sorties de PostgreSQL
```

### Erreurs sur le diagramme ER

- La table `Genre` ne devrait pas inclure d'attribut de date de sortie, contrairement à ce qui est indiqué sur le diagramme.
- La table `Person` ne devrait contenir que le nom complet de la personne, sans distinction de prénom, nom de famille, etc.
- Plusieurs tables liées à la recommandation ne sont pas incluses dans le diagramme ER, car elles sont générées dynamiquement ou ont été ajoutées après la conception initiale.
