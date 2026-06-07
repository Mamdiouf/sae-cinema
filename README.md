# Cinémathèque

Application web de gestion d'une base de données de films, réalisée dans le cadre de la SAE.
Développée en PHP avec PDO et une base de données MySQL.

Auteurs : Mamadou DIOUF et Yacine FALL.

## Technologies

- PHP 8 (PDO)
- MySQL
- HTML / CSS, un peu de JavaScript
- Serveur local : MAMP ou XAMPP
- Git pour le suivi de version

## Structure du projet

```
sae-cinema/
├── db.php                 # connexion à la base (PDO)
├── index.php              # accueil : liste des films
├── film.php               # fiche d'un film (relations, analyse, films similaires)
├── ajouter.php            # formulaire d'ajout d'un film
├── supprimer.php          # suppression d'un film
├── realisateurs.php       # liste des réalisateurs
├── acteurs.php            # liste des acteurs
├── livres.php             # liste des livres et de leurs adaptations
├── includes/
│   ├── header.php         # en-tête + menu
│   ├── footer.php         # pied de page
│   └── fonctions.php      # fonctions d'affichage (étoiles, affiche)
├── assets/
│   └── style.css          # feuille de style
├── scriptsSql/
│   ├── schema.sql         # création de la base + données
│   └── ajout_analyse.sql  # script pour ajouter les colonnes d'analyse
└── README.md
```

## Base de données

La base s'appelle `cinema` et contient huit tables.

| Table | Rôle |
|-------|------|
| `realisateurs` | les réalisateurs |
| `livres` | les livres adaptés (titre, auteur, année, programme) |
| `films` | les films (clés étrangères `id_realisateur` et `id_livre`) |
| `fiches_techniques` | budget, recette, synopsis et analyse d'un film |
| `acteurs` | les acteurs |
| `casting` | association films / acteurs |
| `genres` | les genres |
| `film_genre` | association films / genres |

### Les relations

- 1-1 : `films` et `fiches_techniques`. Un film a une seule fiche technique. La clé primaire de la fiche (`id_film`) est aussi sa clé étrangère, ce qui empêche d'avoir deux fiches pour un même film.
- 1-N : `realisateurs` vers `films` (un réalisateur, plusieurs films) et `livres` vers `films` (un livre peut avoir plusieurs adaptations).
- N-N : `films` et `acteurs` (table `casting`), `films` et `genres` (table `film_genre`).

## Installation

Sous MAMP (Windows) ou XAMPP :

1. Copier le dossier `sae-cinema` dans `htdocs` (MAMP : `C:\MAMP\htdocs\`, XAMPP : `C:\xampp\htdocs\`).
2. Démarrer le serveur (Apache + MySQL).
3. Ouvrir phpMyAdmin, onglet Importer, choisir `scriptsSql/schema.sql` puis exécuter. Le script crée la base `cinema` et insère les données.
4. Vérifier les identifiants dans `db.php` :
   - MAMP : utilisateur `root`, mot de passe `root`.
   - XAMPP : utilisateur `root`, mot de passe vide.
5. Ouvrir http://localhost/sae-cinema/

## Fonctionnalités

- Liste des films sous forme d'affiches, avec la note et les genres.
- Fiche d'un film : synopsis, réalisateur, casting, genres, et le livre d'origine quand c'est une adaptation.
- Analyse détaillée par onglets (thèmes, analyse, message, questions).
- Recommandation de films similaires (même réalisateur ou genres en commun).
- Ajout et suppression d'un film.
- Pages réalisateurs, acteurs et livres.

## Sécurité

- Les requêtes qui utilisent des données de l'utilisateur sont préparées (`prepare` / `execute`), ce qui protège des injections SQL.
- Les affichages passent par `htmlspecialchars()` pour éviter les failles XSS.
- L'ajout d'un film se fait dans une transaction (le film et sa fiche sont enregistrés ensemble).

## Données

Les films, livres et réalisateurs sont des œuvres réelles (classiques de la littérature française et cinéma sénégalais), saisies à la main dans le script SQL pour la démonstration.
