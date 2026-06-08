-- ============================================================
--  Migration : ajoute les colonnes d'analyse a fiches_techniques
--  A executer dans phpMyAdmin (base "cinema") SI la base existe deja
--  et qu'on ne veut PAS tout reimporter.
-- ============================================================
USE cinema;

ALTER TABLE fiches_techniques
    ADD COLUMN themes    TEXT NULL AFTER synopsis,
    ADD COLUMN analyse   TEXT NULL AFTER themes,
    ADD COLUMN message   TEXT NULL AFTER analyse,
    ADD COLUMN questions TEXT NULL AFTER message;

-- Contenu d'exemple pour les films deja presents
UPDATE fiches_techniques SET
    themes    = 'Le rêve et la réalité ; la culpabilité ; la frontière entre le conscient et l''inconscient.',
    analyse   = 'Nolan construit un récit à plusieurs niveaux de rêves imbriqués où le temps se dilate. La toupie finale laisse le spectateur dans le doute.',
    message   = 'Nos souvenirs et nos regrets façonnent la réalité que l''on choisit d''habiter.',
    questions = 'La dernière scène est-elle un rêve ? Peut-on vraiment distinguer le rêve de la réalité ?'
WHERE id_film = 1;

UPDATE fiches_techniques SET
    themes    = 'L''amour comme force ; le temps et la relativité ; la survie de l''humanité.',
    analyse   = 'Le film mêle science (relativité, trous noirs) et émotion : la dilatation du temps sépare un père de sa fille.',
    message   = 'L''amour transcende le temps et l''espace.',
    questions = 'L''amour peut-il être une dimension physique ? Faut-il quitter la Terre pour survivre ?'
WHERE id_film = 2;

UPDATE fiches_techniques SET
    themes    = 'La rédemption ; le hasard ; la violence et la morale.',
    analyse   = 'Récit non linéaire en chapitres entrecroisés ; Tarantino joue avec la chronologie et les dialogues.',
    message   = 'Le hasard et les choix moraux peuvent offrir une seconde chance.',
    questions = 'La structure non linéaire change-t-elle le sens de l''histoire ? Jules connaît-il une vraie rédemption ?'
WHERE id_film = 3;

UPDATE fiches_techniques SET
    themes    = 'Le passage à l''âge adulte ; l''identité ; le respect de la nature.',
    analyse   = 'Conte initiatique où Chihiro perd son nom et doit le retrouver pour exister ; une critique de la société de consommation.',
    message   = 'Garder son identité et son courage permet de grandir.',
    questions = 'Que symbolise la perte du nom ? Sans-Visage représente-t-il la solitude moderne ?'
WHERE id_film = 4;

UPDATE fiches_techniques SET
    themes    = 'Le pouvoir et la religion ; l''écologie ; le destin.',
    analyse   = 'Adaptation du roman de Frank Herbert : la lutte pour l''épice sur Arrakis, fresque politique et écologique.',
    message   = 'La soif de pouvoir et de ressources peut détruire des peuples entiers.',
    questions = 'Paul est-il un héros ou un futur tyran ? Quel rôle joue l''écologie d''Arrakis ?'
WHERE id_film = 5;

UPDATE fiches_techniques SET
    themes    = 'L''humain et l''artificiel ; la mémoire ; l''identité.',
    analyse   = 'Suite du film de 1982 : un réplicant cherche la vérité sur ses origines et sur ce qui fait un être humain.',
    message   = 'C''est la capacité d''aimer et de choisir, plus que l''origine, qui définit l''humanité.',
    questions = 'Qu''est-ce qui distingue un humain d''un réplicant ? La mémoire fait-elle l''identité ?'
WHERE id_film = 6;
