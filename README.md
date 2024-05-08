# CineNet

Forum social pour les fans de cinéma, basé sur une base de données, utilisant PostgreSQL pour le traitement des données et des requêtes SQL interactives pour un contenu personnalisé et des recommandations.

### Installation :

1. Clonez le dépôt Git sur votre machine locale :

```bash
$ git clone git@github.com:mathusanm6/CineNet.git
```

2. Assurez-vous que vous avez PostgreSQL installé sur votre machine.

3. Assurez-vous que vous avez Python 3 installé sur votre machine.

4. Installez les dépendances Python requises en exécutant la commande suivante à la racine du projet:

```bash
$ pip3 install -r requirements.txt
```

5. Assurez-vous que vous avez les droits d'exécution pour le script bash `run.sh` en exécutant la commande suivante à la racine du projet:

```bash
$ chmod +x ./run.sh
```

### Utilisation :

Pour utiliser le programme CineNet, lancez le script bash `run.sh` à la racine du projet avec les options et un argument supplémentaire pour contrôler l'affichage des détails de sortie. Voici les options que vous pouvez spécifier :

- **1** : Pour exécuter uniquement le script `create_db.sh`, qui crée la base de données.
- **2** : Pour exécuter uniquement le script `generate_csv.py`, qui génère des fichiers CSV à partir des données intéressantes.
- **3** : Pour exécuter uniquement le script `import_data.sh`, qui importe les données depuis les fichiers CSV dans la base de données.
- **4** : Pour exécuter uniquement le script `init_recommendation.sh`, qui initialise le système de recommandation.
- **all** : Pour exécuter tous les scripts dans l'ordre : `create_db.sh`, `generate_csv.py` et enfin `import_data.sh`.
- **interactive** : Pour lancer une session interactive de requêtes SQL sur la base de données.

Chaque commande sauf `interactive` prend un argument supplémentaire pour contrôler l'affichage des détails de sortie. Les options sont :
- **yes** : Pour afficher les détails de sortie de PostgreSQL.
- **no** : Pour ne pas afficher les détails de sortie de PostgreSQL.

#### Exemples d'utilisation :

```bash
$ ./run.sh 1 yes  # Crée uniquement la base de données et affiche les sorties de PostgreSQL
$ ./run.sh 2 no   # Exécute uniquement generate_csv.py sans afficher les sorties de PostgreSQL
$ ./run.sh 3 yes  # Exécute seulement import_data.sh et affiche les sorties de PostgreSQL
$ ./run.sh 4 no   # Démarre uniquement init_recommendation.sh sans afficher les sorties de PostgreSQL
$ ./run.sh all yes  # Exécute tous les scripts sauf init_recommendation.sh en séquence et affiche les sorties de PostgreSQL
$ ./run.sh interactive  # Démarre une session interactive de requêtes SQL
```

### Erreurs sur le diagramme ER

- La table `Genre` ne devrait pas inclure d'attribut de date de sortie, contrairement à ce qui est indiqué sur le diagramme.
- La table `Person` ne devrait contenir que le nom complet de la personne, sans distinction de prénom, nom de famille, etc.
- Plusieurs tables liées à la recommandation ne sont pas incluses dans le diagramme ER, car elles sont générées dynamiquement ou ont été ajoutées après la conception initiale.
