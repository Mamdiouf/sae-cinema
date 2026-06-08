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
--  TABLE : livres
--  Un livre peut etre adapte en plusieurs films  ->  relation 1-N
--  (le cote "N" sera la colonne id_livre dans la table films)
-- ------------------------------------------------------------
CREATE TABLE livres (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    titre     VARCHAR(150) NOT NULL,
    auteur    VARCHAR(120) NOT NULL,
    annee     SMALLINT     DEFAULT NULL,        -- annee de publication
    programme VARCHAR(40)  DEFAULT NULL         -- ex : 'Classique FR', 'Senegal'
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
    affiche        VARCHAR(500) DEFAULT NULL,           -- URL de l'affiche
    note           DECIMAL(2,1) DEFAULT NULL,           -- note sur 5
    id_realisateur INT          NOT NULL,
    id_livre       INT          DEFAULT NULL,           -- livre adapte (NULL si film original)
    CONSTRAINT fk_film_realisateur
        FOREIGN KEY (id_realisateur) REFERENCES realisateurs(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_film_livre
        FOREIGN KEY (id_livre) REFERENCES livres(id)
        ON DELETE SET NULL
);

-- ------------------------------------------------------------
--  TABLE : fiches_techniques
--  UN film  <->  UNE fiche  ->  relation 1-1
--  (la cle primaire EST la cle etrangere = garantit le 1-1)
-- ------------------------------------------------------------
CREATE TABLE fiches_techniques (
    id_film   INT PRIMARY KEY,
    budget    BIGINT      DEFAULT NULL,                 -- en dollars
    recette   BIGINT      DEFAULT NULL,
    synopsis  TEXT        DEFAULT NULL,
    themes    TEXT        DEFAULT NULL,                 -- analyse : themes du film
    analyse   TEXT        DEFAULT NULL,                 -- analyse detaillee
    message   TEXT        DEFAULT NULL,                 -- message principal
    questions TEXT        DEFAULT NULL,                 -- questions de reflexion
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

INSERT INTO fiches_techniques (id_film, budget, recette, synopsis, themes, analyse, message, questions) VALUES
(1, 160000000, 829895144,
 'Un voleur capable d''entrer dans les rêves se voit offrir une chance de retrouver sa vie d''avant.',
 'Le rêve et la réalité ; la culpabilité ; la frontière entre le conscient et l''inconscient.',
 'Nolan construit un récit à plusieurs niveaux de rêves imbriqués où le temps se dilate. La toupie finale laisse le spectateur dans le doute.',
 'Nos souvenirs et nos regrets façonnent la réalité que l''on choisit d''habiter.',
 'La dernière scène est-elle un rêve ? Peut-on vraiment distinguer le rêve de la réalité ?'),
(2, 165000000, 677471339,
 'Des explorateurs voyagent à travers un trou de ver pour sauver l''humanité.',
 'L''amour comme force ; le temps et la relativité ; la survie de l''humanité.',
 'Le film mêle science (relativité, trous noirs) et émotion : la dilatation du temps sépare un père de sa fille.',
 'L''amour transcende le temps et l''espace.',
 'L''amour peut-il être une dimension physique ? Faut-il quitter la Terre pour survivre ?'),
(3, 8000000, 213928762,
 'Les destins entrecroisés de truands à Los Angeles.',
 'La rédemption ; le hasard ; la violence et la morale.',
 'Récit non linéaire en chapitres entrecroisés ; Tarantino joue avec la chronologie et les dialogues.',
 'Le hasard et les choix moraux peuvent offrir une seconde chance.',
 'La structure non linéaire change-t-elle le sens de l''histoire ? Jules connaît-il une vraie rédemption ?'),
(4, 19000000, 395802070,
 'Une fillette se retrouve piégée dans un monde peuplé d''esprits.',
 'Le passage à l''âge adulte ; l''identité ; le respect de la nature.',
 'Conte initiatique où Chihiro perd son nom et doit le retrouver pour exister ; une critique de la société de consommation.',
 'Garder son identité et son courage permet de grandir.',
 'Que symbolise la perte du nom ? Sans-Visage représente-t-il la solitude moderne ?'),
(5, 165000000, 402027830,
 'Paul Atréides rejoint le peuple Fremen sur la planète désertique Arrakis.',
 'Le pouvoir et la religion ; l''écologie ; le destin.',
 'Adaptation du roman de Frank Herbert : la lutte pour l''épice sur Arrakis, fresque politique et écologique.',
 'La soif de pouvoir et de ressources peut détruire des peuples entiers.',
 'Paul est-il un héros ou un futur tyran ? Quel rôle joue l''écologie d''Arrakis ?'),
(6, 185000000, 259239658,
 'Un nouveau blade runner découvre un secret qui pourrait plonger la société dans le chaos.',
 'L''humain et l''artificiel ; la mémoire ; l''identité.',
 'Suite du film de 1982 : un réplicant cherche la vérité sur ses origines et sur ce qui fait un être humain.',
 'C''est la capacité d''aimer et de choisir, plus que l''origine, qui définit l''humanité.',
 'Qu''est-ce qui distingue un humain d''un réplicant ? La mémoire fait-elle l''identité ?');

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


-- ============================================================
--  EXTENSION : FILMS ISSUS DE LIVRES (classiques FR + Senegal)
--  Montre la relation 1-N : un livre -> une ou plusieurs adaptations.
-- ============================================================

-- Genres supplementaires
INSERT INTO genres (id, nom) VALUES
(6, 'Aventure'), (7, 'Comédie'), (8, 'Historique'), (9, 'Romance');

-- Realisateurs supplementaires
INSERT INTO realisateurs (id, nom, prenom, nationalite) VALUES
(5,  'Hooper',      'Tom',       'Britannique'),
(6,  'Berri',       'Claude',    'Française'),
(7,  'Chabrol',     'Claude',    'Française'),
(8,  'Autant-Lara', 'Claude',    'Française'),
(9,  'Delaporte',   'Matthieu',  'Française'),
(10, 'Bourboulon',  'Martin',    'Française'),
(11, 'Rappeneau',   'Jean-Paul', 'Française'),
(12, 'Visconti',    'Luchino',   'Italienne'),
(13, 'Osborne',     'Mark',      'Américaine'),
(14, 'Frears',      'Stephen',   'Britannique'),
(15, 'Sembène',     'Ousmane',   'Sénégalaise'),
(16, 'Diabang',     'Angèle',    'Sénégalaise');

-- Livres (cote "1" de la relation 1-N)
INSERT INTO livres (id, titre, auteur, annee, programme) VALUES
(1,  'Les Misérables',           'Victor Hugo',                1862, 'Classique FR'),
(2,  'Germinal',                 'Émile Zola',                 1885, 'Classique FR'),
(3,  'Madame Bovary',            'Gustave Flaubert',           1857, 'Classique FR'),
(4,  'Le Rouge et le Noir',      'Stendhal',                   1830, 'Classique FR'),
(5,  'Le Comte de Monte-Cristo', 'Alexandre Dumas',            1844, 'Classique FR'),
(6,  'Les Trois Mousquetaires',  'Alexandre Dumas',            1844, 'Classique FR'),
(7,  'Cyrano de Bergerac',       'Edmond Rostand',             1897, 'Classique FR'),
(8,  'L''Étranger',              'Albert Camus',               1942, 'Classique FR'),
(9,  'Le Petit Prince',          'Antoine de Saint-Exupéry',   1943, 'Classique FR'),
(10, 'Les Liaisons dangereuses', 'Choderlos de Laclos',        1782, 'Classique FR'),
(11, 'Le Mandat',                'Ousmane Sembène',            1966, 'Sénégal'),
(12, 'Xala',                     'Ousmane Sembène',            1973, 'Sénégal'),
(13, 'La Noire de…',             'Ousmane Sembène',            1962, 'Sénégal'),
(14, 'Une si longue lettre',     'Mariama Bâ',                 1979, 'Sénégal');

-- Films adaptes (cote "N" : chaque film pointe vers son livre)
INSERT INTO films (id, titre, annee, duree, note, id_realisateur, id_livre) VALUES
(7,  'Les Misérables',                 2012, 158, 4.2,  5,  1),
(8,  'Germinal',                       1993, 160, 4.1,  6,  2),
(9,  'Madame Bovary',                  1991, 143, 3.8,  7,  3),
(10, 'Le Rouge et le Noir',            1954, 145, 3.9,  8,  4),
(11, 'Le Comte de Monte-Cristo',       2024, 178, 4.5,  9,  5),
(12, 'Les Trois Mousquetaires : D''Artagnan', 2023, 121, 4.0, 10, 6),
(13, 'Cyrano de Bergerac',             1990, 138, 4.4, 11,  7),
(14, 'L''Étranger',                    1967, 104, 3.9, 12,  8),
(15, 'Le Petit Prince',                2015, 106, 4.2, 13,  9),
(16, 'Les Liaisons dangereuses',       1988, 119, 4.3, 14, 10),
(17, 'Mandabi',                        1968,  92, 4.3, 15, 11),
(18, 'Xala',                           1975, 123, 4.2, 15, 12),
(19, 'La Noire de…',                   1966,  65, 4.4, 15, 13),
(20, 'Une si longue lettre',           2025, 100, 4.2, 16, 14);

-- Fiches techniques (synopsis) des films adaptes
INSERT INTO fiches_techniques (id_film, synopsis) VALUES
(7,  'Dans la France du XIXe siècle, l''ancien bagnard Jean Valjean cherche la rédemption, traqué sans relâche par l''inspecteur Javert.'),
(8,  'Dans le Nord minier, le jeune Étienne Lantier mène la révolte des mineurs contre la misère et l''injustice.'),
(9,  'Emma, épouse d''un médecin de province, fuit l''ennui dans l''adultère et les dettes, jusqu''au drame.'),
(10, 'Julien Sorel, fils de charpentier ambitieux, gravit la société par l''amour et l''hypocrisie.'),
(11, 'Trahi et emprisonné, Edmond Dantès s''évade et orchestre patiemment sa vengeance sous une fausse identité.'),
(12, 'Le jeune d''Artagnan rejoint les mousquetaires du roi dans une France pleine d''intrigues et de complots.'),
(13, 'Cyrano, poète au grand nez, aime Roxane en secret mais prête ses mots au beau Christian.'),
(14, 'Meursault, indifférent au monde, commet un meurtre et est jugé autant pour son absence d''émotion que pour son crime.'),
(15, 'Une petite fille découvre, grâce à un vieil aviateur, l''histoire du Petit Prince venu d''une autre planète.'),
(16, 'La marquise de Merteuil et le vicomte de Valmont se livrent à un jeu cruel de séduction et de manipulation.'),
(17, 'À Dakar, un homme reçoit un mandat de son neveu de Paris et se heurte à l''absurdité de la bureaucratie.'),
(18, 'Un homme d''affaires polygame de Dakar est frappé d''une malédiction d''impuissance le jour de son troisième mariage.'),
(19, 'Une jeune Sénégalaise part travailler en France pour une famille française et y découvre la solitude et le mépris.'),
(20, 'Ramatoulaye, institutrice à Dakar, confie dans une longue lettre sa vie bouleversée par la polygamie.');

-- Genres des films adaptes (relation N-N)
INSERT INTO film_genre (id_film, id_genre) VALUES
(7,3),(7,8),
(8,3),(8,8),
(9,3),
(10,3),
(11,6),(11,3),
(12,6),(12,2),
(13,3),(13,9),(13,7),
(14,3),
(15,4),(15,6),
(16,3),(16,9),
(17,3),(17,7),
(18,3),(18,7),
(19,3),
(20,3),(20,9);

-- Analyse detaillee des films adaptes (themes / analyse / message / questions)
UPDATE fiches_techniques SET
 themes='La justice et la loi ; la rédemption ; la misère sociale ; la charité.',
 analyse='Fresque sociale du XIXe siècle : Hugo dénonce la misère et plaide pour la rédemption à travers le parcours de Jean Valjean, opposé à la rigidité de Javert.',
 message='L''amour et la compassion peuvent racheter une vie et valent mieux que la loi aveugle.',
 questions='La loi est-elle toujours juste ? Un homme peut-il vraiment changer ?' WHERE id_film=7;
UPDATE fiches_techniques SET
 themes='La lutte des classes ; le travail et l''exploitation ; la solidarité ouvrière ; l''espoir.',
 analyse='Roman naturaliste : Zola peint la condition des mineurs et la naissance de la conscience ouvrière à travers la grève menée par Étienne Lantier.',
 message='De la misère peut germer la révolte et l''espoir d''un monde plus juste.',
 questions='La grève est-elle un échec ou une victoire ? Le progrès social justifie-t-il la violence ?' WHERE id_film=8;
UPDATE fiches_techniques SET
 themes='L''ennui et l''insatisfaction ; le romantisme face au réel ; la condition féminine ; les illusions.',
 analyse='Flaubert dépeint le « bovarysme » : Emma, nourrie de romans, fuit la banalité par l''adultère et se perd dans l''illusion.',
 message='La fuite dans le rêve et les apparences mène à la chute.',
 questions='Emma est-elle coupable ou victime de son époque ? Les rêves peuvent-ils nous perdre ?' WHERE id_film=9;
UPDATE fiches_techniques SET
 themes='L''ambition ; l''hypocrisie sociale ; l''amour et l''orgueil ; l''ascension sociale.',
 analyse='Stendhal suit Julien Sorel, jeune ambitieux qui utilise l''Église (le noir) faute d''armée (le rouge) pour s''élever, entre sincérité et calcul.',
 message='L''ambition sans scrupules se heurte aux barrières sociales et conduit au drame.',
 questions='Julien est-il un arriviste ou un idéaliste ? La société permet-elle l''ascension par le mérite ?' WHERE id_film=10;
UPDATE fiches_techniques SET
 themes='La vengeance ; la justice ; la trahison ; la providence.',
 analyse='Roman d''aventures : Edmond Dantès, injustement emprisonné, revient riche et masqué pour punir ses traîtres, jusqu''à interroger les limites de la vengeance.',
 message='La vengeance peut être grisante mais elle ne rend ni la paix ni l''innocence perdue.',
 questions='La vengeance est-elle justice ? Jusqu''où peut-on aller pour réparer une injustice ?' WHERE id_film=11;
UPDATE fiches_techniques SET
 themes='L''amitié ; l''honneur ; l''aventure ; la fidélité.',
 analyse='Roman de cape et d''épée : d''Artagnan et les mousquetaires défendent l''honneur et la couronne dans une France d''intrigues.',
 message='« Un pour tous, tous pour un » : l''amitié et la loyauté triomphent des complots.',
 questions='L''honneur vaut-il qu''on risque sa vie ? L''amitié peut-elle tout surmonter ?' WHERE id_film=12;
UPDATE fiches_techniques SET
 themes='L''amour impossible ; l''apparence et l''âme ; le panache ; le sacrifice.',
 analyse='Pièce en vers : Cyrano, brillant mais complexé par son nez, aime Roxane et lui parle à travers Christian, sacrifiant son bonheur.',
 message='La beauté de l''âme et des mots vaut plus que l''apparence.',
 questions='Faut-il toujours avouer ses sentiments ? L''apparence détermine-t-elle l''amour ?' WHERE id_film=13;
UPDATE fiches_techniques SET
 themes='L''absurde ; l''indifférence ; la justice et la société ; la condition humaine.',
 analyse='Roman de l''absurde : Meursault, étranger aux conventions, est condamné autant pour son indifférence aux rites sociaux que pour son meurtre.',
 message='La société condamne celui qui refuse de jouer ses codes et de feindre les émotions.',
 questions='Meursault est-il jugé pour son crime ou pour son indifférence ? Qu''est-ce qu''une vie « normale » ?' WHERE id_film=14;
UPDATE fiches_techniques SET
 themes='L''enfance ; l''amitié et l''amour ; le regard du cœur ; la critique du monde des adultes.',
 analyse='Conte philosophique : à travers ses rencontres, le Petit Prince révèle l''absurdité du monde des « grandes personnes » et la valeur des liens.',
 message='On ne voit bien qu''avec le cœur ; l''essentiel est invisible pour les yeux.',
 questions='Qu''avons-nous oublié de notre enfance ? Qu''est-ce qui rend un être « unique » ?' WHERE id_film=15;
UPDATE fiches_techniques SET
 themes='La manipulation ; le libertinage ; le pouvoir et la séduction ; la morale.',
 analyse='Roman épistolaire : Merteuil et Valmont font de la séduction un jeu de pouvoir cruel, qui finit par se retourner contre eux.',
 message='Le cynisme et la manipulation finissent par détruire ceux qui les pratiquent.',
 questions='La séduction peut-elle être une arme ? La vertu affichée cache-t-elle le vice ?' WHERE id_film=16;
UPDATE fiches_techniques SET
 themes='La bureaucratie ; la modernité face à la tradition ; la pauvreté ; la dignité.',
 analyse='Sembène filme en wolof un homme simple écrasé par l''administration et l''argent : satire de la société post-coloniale sénégalaise.',
 message='Les petites gens sont broyées par un système qui ne les protège pas.',
 questions='La modernité aide-t-elle ou écrase-t-elle les plus humbles ? Qu''est-ce que la dignité face à la pauvreté ?' WHERE id_film=17;
UPDATE fiches_techniques SET
 themes='La corruption ; le néocolonialisme ; la polygamie ; le ridicule du pouvoir.',
 analyse='Satire mordante : l''impuissance (le « xala ») d''un notable devient la métaphore d''une bourgeoisie africaine corrompue et coupée de son peuple.',
 message='Une élite qui imite l''ancien colonisateur et oublie son peuple se condamne elle-même.',
 questions='Que critique le symbole du « xala » ? L''indépendance a-t-elle vraiment changé la société ?' WHERE id_film=18;
UPDATE fiches_techniques SET
 themes='Le racisme ; l''exil et l''isolement ; l''aliénation ; la dignité.',
 analyse='Considéré comme le premier long métrage d''Afrique subsaharienne : Diouana, employée en France, sombre dans la solitude et la déshumanisation.',
 message='L''exil et le mépris peuvent détruire une personne privée de sa dignité.',
 questions='Que dénonce le silence de Diouana ? Quel regard le film porte-t-il sur la décolonisation ?' WHERE id_film=19;
UPDATE fiches_techniques SET
 themes='La condition féminine ; la polygamie ; l''amitié entre femmes ; l''éducation ; tradition et modernité.',
 analyse='Adapté du roman épistolaire de Mariama Bâ : Ramatoulaye, veuve, confie à son amie Aïssatou sa vie face à la polygamie et au poids des traditions.',
 message='L''éducation et la solidarité féminine sont des forces face à l''injustice.',
 questions='Comment concilier tradition et droits des femmes ? Quel rôle joue l''amitié dans l''épreuve ?' WHERE id_film=20;

-- Affiches reelles trouvees (les autres films restent en carte-titre)
UPDATE films SET affiche='https://media.senscritique.com/media/000000105968/0/madame_bovary.jpg' WHERE id=9;
UPDATE films SET affiche='https://bullesdeculture.com/bdc-content/uploads/2024/06/le-comte-de-monte-cristo-2024-affiche.jpg' WHERE id=11;
UPDATE films SET affiche='https://upload.wikimedia.org/wikipedia/commons/5/52/L%27Affiche_du_film_L%27etranger.jpg' WHERE id=14;
UPDATE films SET affiche='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdG3cWwl6QN9By_IxHQp5lW8qK_78uGZjV-h6jo4n5Ign_CJHrWTs_frHI6uc0Xxdo9JaWmMpAPFEj9aYHZUXLGSJr7ZBNn3fH11ZbfSzo_Q&s=10' WHERE id=10;
UPDATE films SET affiche='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhDmzD2-CYifgaa6eKljghpgcsNKdHN0TRdh1X76GbfA&s=10' WHERE id=12;
UPDATE films SET affiche='https://image.over-blog.com/a7ZmykxTZudWdGiXs7r-OsG3zlk=/filters:no_upscale()/image%2F0935117%2F20211218%2Fob_87e6d7_cyrano-3.jpg' WHERE id=13;
UPDATE films SET affiche='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp6wk12HeWaGoQtcuiTNndiLLdRGbB4edTAmSHr7kHCVJrlUj4tZBjNuUc&s=10' WHERE id=18;
UPDATE films SET affiche='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAdgk0wDllehiVT4688XShPUW2recedpDXiWEQf_5FDq9tH0GKe7n9oY8&s=10' WHERE id=20;
UPDATE films SET affiche='https://s3.amazonaws.com/criterion-production/films/f80481e779fb4ee322ea076493f77809/aL8C9iixqiOxtqyTVPNMPTPQwrBtKl_large.jpg' WHERE id=19;
UPDATE films SET affiche='https://upload.wikimedia.org/wikipedia/en/f/fc/Mandabi_poster_%28French%29.jpg' WHERE id=17;
UPDATE films SET affiche='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbiXL2IsmmpklkNzKuwdUMPCroNrzpxhPYyJ64jel8RlUuFCmXmji1cLxZ&s=10' WHERE id=16;
UPDATE films SET affiche='https://fr.web.img3.acsta.net/c_310_420/pictures/15/07/10/11/39/234930.jpg' WHERE id=15;
UPDATE films SET affiche='https://fr.web.img3.acsta.net/c_310_420/medias/nmedia/18/91/00/76/20364091.jpg' WHERE id=7;
UPDATE films SET affiche='https://d2u1z1lopyfwlx.cloudfront.net/thumbnails/5e89a4cf-3281-5b1c-ba67-b58b5fceab1f/19fff8e5-c8d2-5bcc-b34c-43e2ef28b80a.jpg' WHERE id=8;

-- ============================================================
--  Acteurs des films adaptes + casting (relation N-N)
-- ============================================================
INSERT INTO acteurs (id, nom, prenom) VALUES
(7,'Jackman','Hugh'),(8,'Crowe','Russell'),(9,'Hathaway','Anne'),
(10,'Depardieu','Gérard'),(11,'Huppert','Isabelle'),(12,'Balmer','Jean-François'),
(13,'Philipe','Gérard'),(14,'Darrieux','Danielle'),(15,'Niney','Pierre'),
(16,'Demoustier','Anaïs'),(17,'Civil','François'),(18,'Cassel','Vincent'),
(19,'Green','Eva'),(20,'Duris','Romain'),(21,'Marmaï','Pio'),
(22,'Brochet','Anne'),(23,'Perez','Vincent'),(24,'Mastroianni','Marcello'),
(25,'Karina','Anna'),(26,'Dussollier','André'),(27,'Close','Glenn'),
(28,'Malkovich','John'),(29,'Pfeiffer','Michelle'),(30,'Gueye','Makhouredia'),
(31,'Leye','Thierno'),(32,'Diop','Mbissine Thérèse'),(33,'Mbaye','Amélie'),
(34,'Hiiragi','Rumi'),(35,'Irino','Miyu'),(36,'Miou-Miou','');

INSERT INTO casting (id_film, id_acteur, role) VALUES
(4,34,'Chihiro (voix)'),(4,35,'Haku (voix)'),
(7,7,'Jean Valjean'),(7,8,'Javert'),(7,9,'Fantine'),
(8,10,'Maheu'),(8,36,'La Maheude'),
(9,11,'Emma Bovary'),(9,12,'Charles Bovary'),
(10,13,'Julien Sorel'),(10,14,'Madame de Rênal'),
(11,15,'Edmond Dantès'),(11,16,'Mercédès'),
(12,17,'D''Artagnan'),(12,18,'Athos'),(12,19,'Milady de Winter'),(12,20,'Aramis'),(12,21,'Porthos'),
(13,10,'Cyrano de Bergerac'),(13,22,'Roxane'),(13,23,'Christian'),
(14,24,'Meursault'),(14,25,'Marie'),
(15,26,'L''aviateur (voix)'),
(16,27,'Marquise de Merteuil'),(16,28,'Vicomte de Valmont'),(16,29,'Madame de Tourvel'),
(17,30,'Ibrahima Dieng'),
(18,31,'El Hadji'),
(19,32,'Diouana'),
(20,33,'Ramatoulaye');
