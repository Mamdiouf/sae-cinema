-- ============================================================
--  SAE - Application de gestion de Cinema
--  Script de creation de la base de donnees + jeu de donnees
--  A importer dans phpMyAdmin (MAMP) OU via la ligne de commande
-- ============================================================

-- On supprime la base si elle existe deja (pour repartir propre)
DROP DATABASE IF EXISTS cinema;
CREATE DATABASE cinema CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cinema;

-- On force l'encodage UTF-8 pour que les accents soient bien enregistres
SET NAMES utf8mb4;

-- ------------------------------------------------------------
--  TABLE : realisateurs
--  (cote "1" de la relation 1-N avec films)
-- ------------------------------------------------------------
CREATE TABLE realisateurs (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nom         VARCHAR(80)  NOT NULL,
    prenom      VARCHAR(80)  NOT NULL,
    nationalite VARCHAR(60)  DEFAULT NULL
);

-- ------------------------------------------------------------
--  TABLE : films
--  Chaque film appartient a UN realisateur  ->  relation 1-N
-- ------------------------------------------------------------
CREATE TABLE films (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    titre          VARCHAR(150) NOT NULL,
    annee          SMALLINT     DEFAULT NULL,
    duree          INT          DEFAULT NULL,           -- en minutes
    affiche        VARCHAR(255) DEFAULT NULL,           -- URL de l'affiche
    note           DECIMAL(2,1) DEFAULT NULL,           -- note sur 5
    id_realisateur INT          NOT NULL,
    CONSTRAINT fk_film_realisateur
        FOREIGN KEY (id_realisateur) REFERENCES realisateurs(id)
        ON DELETE CASCADE
);

-- ------------------------------------------------------------
--  TABLE : fiches_techniques
--  UN film  <->  UNE fiche  ->  relation 1-1
--  (la cle primaire EST la cle etrangere = garantit le 1-1)
-- ------------------------------------------------------------
CREATE TABLE fiches_techniques (
    id_film  INT PRIMARY KEY,
    budget   BIGINT       DEFAULT NULL,                 -- en dollars
    recette  BIGINT       DEFAULT NULL,
    synopsis TEXT         DEFAULT NULL,
    CONSTRAINT fk_fiche_film
        FOREIGN KEY (id_film) REFERENCES films(id)
        ON DELETE CASCADE
);

-- ------------------------------------------------------------
--  TABLE : acteurs
-- ------------------------------------------------------------
CREATE TABLE acteurs (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    nom    VARCHAR(80) NOT NULL,
    prenom VARCHAR(80) NOT NULL
);

-- ------------------------------------------------------------
--  TABLE : casting  (table d'association)
--  Plusieurs films <-> plusieurs acteurs  ->  relation N-N
-- ------------------------------------------------------------
CREATE TABLE casting (
    id_film   INT NOT NULL,
    id_acteur INT NOT NULL,
    role      VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (id_film, id_acteur),
    CONSTRAINT fk_casting_film   FOREIGN KEY (id_film)   REFERENCES films(id)   ON DELETE CASCADE,
    CONSTRAINT fk_casting_acteur FOREIGN KEY (id_acteur) REFERENCES acteurs(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
--  TABLE : genres
-- ------------------------------------------------------------
CREATE TABLE genres (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(60) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
--  TABLE : film_genre  (table d'association)
--  Plusieurs films <-> plusieurs genres  ->  relation N-N
-- ------------------------------------------------------------
CREATE TABLE film_genre (
    id_film  INT NOT NULL,
    id_genre INT NOT NULL,
    PRIMARY KEY (id_film, id_genre),
    CONSTRAINT fk_fg_film  FOREIGN KEY (id_film)  REFERENCES films(id)  ON DELETE CASCADE,
    CONSTRAINT fk_fg_genre FOREIGN KEY (id_genre) REFERENCES genres(id) ON DELETE CASCADE
);

-- ============================================================
--  JEU DE DONNEES (donnees d'exemple)
-- ============================================================

INSERT INTO realisateurs (nom, prenom, nationalite) VALUES
('Nolan',     'Christopher', 'Britannique'),  -- 1
('Tarantino', 'Quentin',     'Américaine'),   -- 2
('Miyazaki',  'Hayao',       'Japonaise'),    -- 3
('Villeneuve','Denis',       'Canadienne');   -- 4

INSERT INTO films (titre, annee, duree, affiche, note, id_realisateur) VALUES
('Inception',            2010, 148, 'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg', 4.7, 1),  -- 1
('Interstellar',         2014, 169, 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', 4.8, 1),  -- 2
('Pulp Fiction',         1994, 154, 'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg', 4.6, 2),  -- 3
('Le Voyage de Chihiro', 2001, 125, 'https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg', 4.9, 3),  -- 4
('Dune',                 2021, 155, 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', 4.3, 4),  -- 5
('Blade Runner 2049',    2017, 164, 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', 4.4, 4);  -- 6

INSERT INTO fiches_techniques (id_film, budget, recette, synopsis) VALUES
(1, 160000000, 829895144, 'Un voleur capable d''entrer dans les rêves se voit offrir une chance de retrouver sa vie d''avant.'),
(2, 165000000, 677471339, 'Des explorateurs voyagent à travers un trou de ver pour sauver l''humanité.'),
(3, 8000000,  213928762, 'Les destins entrecroisés de truands à Los Angeles.'),
(4, 19000000, 395802070, 'Une fillette se retrouve piégée dans un monde peuplé d''esprits.'),
(5, 165000000,402027830, 'Paul Atréides rejoint le peuple Fremen sur la planète désertique Arrakis.'),
(6, 185000000,259239658, 'Un nouveau blade runner découvre un secret qui pourrait plonger la société dans le chaos.');

INSERT INTO acteurs (nom, prenom) VALUES
('DiCaprio', 'Leonardo'),   -- 1
('McConaughey', 'Matthew'), -- 2
('Travolta', 'John'),       -- 3
('Jackson',  'Samuel L.'),  -- 4
('Chalamet', 'Timothee'),   -- 5
('Gosling',  'Ryan');       -- 6

INSERT INTO casting (id_film, id_acteur, role) VALUES
(1, 1, 'Dom Cobb'),
(2, 2, 'Cooper'),
(3, 3, 'Vincent Vega'),
(3, 4, 'Jules Winnfield'),
(5, 5, 'Paul Atreides'),
(6, 6, 'K'),
(6, 1, 'Apparition spéciale');  -- DiCaprio joue aussi dans un 2e film -> montre le N-N

INSERT INTO genres (nom) VALUES
('Science-Fiction'),  -- 1
('Action'),           -- 2
('Drame'),            -- 3
('Animation'),        -- 4
('Thriller');         -- 5

INSERT INTO film_genre (id_film, id_genre) VALUES
(1, 1), (1, 2),          -- Inception : SF + Action
(2, 1), (2, 3),          -- Interstellar : SF + Drame
(3, 3), (3, 5),          -- Pulp Fiction : Drame + Thriller
(4, 4), (4, 3),          -- Chihiro : Animation + Drame
(5, 1), (5, 2),          -- Dune : SF + Action
(6, 1), (6, 5);          -- Blade Runner : SF + Thriller
