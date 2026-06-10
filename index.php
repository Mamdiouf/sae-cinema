<?php
// ============================================================
//  index.php  -  Page d'accueil : grille des films (style affiches)
//  Montre la relation 1-N (film -> réalisateur)
//  et la relation N-N (film -> genres) via GROUP_CONCAT.
// ============================================================
require "db.php";
require "includes/fonctions.php";

$sql = "
    SELECT  f.id, f.titre, f.annee, f.duree, f.affiche, f.note,
            r.nom AS real_nom, r.prenom AS real_prenom,
            GROUP_CONCAT(g.nom ORDER BY g.nom SEPARATOR ', ') AS genres
    FROM films f
    JOIN realisateurs r       ON r.id = f.id_realisateur
    LEFT JOIN film_genre fg   ON fg.id_film = f.id
    LEFT JOIN genres g        ON g.id = fg.id_genre
    GROUP BY f.id
    ORDER BY f.note DESC, f.titre
";
$films = $pdo->query($sql)->fetchAll();

$titrePage = "À l'affiche";
require "includes/header.php";
?>

<h1 class="page-title">À l'affiche</h1>
<p class="page-sub"><?= count($films) ?> films dans la cinémathèque</p>

<?php if (isset($_GET['ok'])): ?>
    <div class="alert ok">✔ Opération réalisée avec succès.</div>
<?php endif; ?>

<div class="films-grid">
    <?php foreach ($films as $film): ?>
        <article class="film-card">
            <a href="film.php?id=<?= (int)$film['id'] ?>">
                <?= affiche($film) ?>
                <h3><?= htmlspecialchars($film['titre']) ?></h3>
            </a>
            <p class="by">
                <?= (int)$film['annee'] ?> · <?= htmlspecialchars($film['real_prenom'].' '.$film['real_nom']) ?>
            </p>
            <?= etoiles($film['note'] !== null ? (float)$film['note'] : null) ?>
        </article>
    <?php endforeach; ?>
</div>

<?php require "includes/footer.php"; ?>
