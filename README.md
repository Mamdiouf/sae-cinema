# 🎬 Cinematheque — SAE PHP / PDO

Application web de gestion d'une base de données de **films**, développée en **PHP 8 + PDO** avec **MySQL/MariaDB** (MAMP).

Ce projet répond au cahier des charges de la SAE : une application interactive connectée à une base de données relationnelle contenant les trois types de relations (**1‑1, 1‑N, N‑N**), avec un code sécurisé grâce aux **requêtes préparées**.

---

## 📂 Structure du projet

```
sae-cinema/
├── db.php                 # Connexion PDO à la base
├── index.php              # Accueil : liste des films
├── film.php               # Détail d'un film (montre les 3 relations)
├── ajouter.php            # Formulaire d'ajout (INSERT + transaction)
├── supprimer.php          # Suppression d'un film
├── realisateurs.php       # Liste des réalisateurs (relation 1-N)
├── acteurs.php            # Liste des acteurs (relation N-N)
├── includes/
│   ├── header.php         # En-tête + navigation (réutilisable)
│   ├── footer.php         # Pied de page
│   └── fonctions.php      # Fonctions d'affichage (étoiles, affiche)
├── assets/
│   └── style.css          # Feuille de style
├── scriptsSql/
│   └── schema.sql         # Création de la base + données d'exemple
└── README.md
```

## 🗄️ Modèle de la base de données

| Table | Rôle |
|-------|------|
| `realisateurs` | Les réalisateurs |
| `films` | Les films (clé étrangère `id_realisateur`) |
| `fiches_techniques` | Budget / recette / synopsis d'un film |
| `acteurs` | Les acteurs |
| `casting` | Association films ↔ acteurs |
| `genres` | Les genres de films |
| `film_genre` | Association films ↔ genres |

### Les 3 relations demandées

- **1‑1** → `films` ↔ `fiches_techniques` : un film possède exactement une fiche technique (la clé primaire de la fiche est aussi sa clé étrangère).
- **1‑N** → `realisateurs` → `films` : un réalisateur réalise plusieurs films, un film a un seul réalisateur.
- **N‑N** → `films` ↔ `acteurs` (via `casting`) et `films` ↔ `genres` (via `film_genre`).

## 🚀 Installation (sous MAMP / Windows)

1. **Copier le dossier** `sae-cinema` dans `C:\MAMP\htdocs\`.
2. **Démarrer MAMP** (serveurs Apache + MySQL).
3. **Importer la base** : ouvrir phpMyAdmin → onglet *Importer* → choisir `scriptsSql/schema.sql` → *Exécuter*.
   *(le script crée lui-même la base `cinema` et insère les données)*
4. **Vérifier `db.php`** : identifiants MAMP par défaut → utilisateur `root`, mot de passe `root`.
5. **Ouvrir l'application** : <http://localhost/sae-cinema/>

## ✨ Fonctionnalités

- 📃 Liste des films sous forme d'affiches, avec note sur 5 et genres
- 🔍 Fiche détaillée d'un film (affiche, synopsis, budget, casting, genres)
- ➕ Ajout d'un film via un formulaire (avec transaction PDO)
- 🗑️ Suppression d'un film (suppression en cascade des données liées)
- 👤 Pages réalisateurs et acteurs avec leurs filmographies

## 🔒 Sécurité

- Toutes les requêtes avec paramètres utilisent des **requêtes préparées** (`prepare` / `execute`) → protection contre les injections SQL.
- Tous les affichages passent par `htmlspecialchars()` → protection contre le XSS.

## 👥 Auteurs

- **Mamadou DIOUF** — mamadou.diouf1@edu.univ-paris13.fr
- **Yacine FALL** — yacine.fall@edu.univ-paris13.fr

## 📝 Source des données

Données d'exemple saisies manuellement à des fins de démonstration.
