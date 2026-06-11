<?php
// ============================================================
//  film.php  -  Fiche détaillée d'un film
//  Relation 1-1 : la fiche technique (budget, recette, synopsis)
//  Relation 1-N : le réalisateur du film
//  Relation N-N : les acteurs (casting) et les genres
//  Toutes les requêtes sont PRÉPARÉES (sécurité anti-injection).
// ============================================================
require "db.php";
require "includes/fonctions.php";

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// --- Film + réalisateur (1-N) + fiche technique (1-1) ---
$req = $pdo->prepare("
    SELECT f.titre, f.annee, f.duree, f.affiche, f.note,
           r.nom AS real_nom, r.prenom AS real_prenom, r.nationalite,
           ft.budget, ft.recette, ft.synopsis
    FROM films f
    JOIN realisateurs r            ON r.id = f.id_realisateur
    LEFT JOIN fiches_techniques ft ON ft.id_film = f.id
    WHERE f.id = ?
");
$req->execute([$id]);
$film = $req->fetch();

if (!$film) {
    $titrePage = "Film introuvable";
    require "includes/header.php";
    echo '<div class="alert error">Ce film n\'existe pas.</div>';
    echo '<a class="btn" href="index.php">Retour à l\'accueil</a>';
    require "includes/footer.php";
    exit;
}

// --- Acteurs du film (N-N) ---
$reqActeurs = $pdo->prepare("
    SELECT a.prenom, a.nom, c.role
    FROM casting c
    JOIN acteurs a ON a.id = c.id_acteur
    WHERE c.id_film = ?
    ORDER BY a.nom
");
$reqActeurs->execute([$id]);
$acteurs = $reqActeurs->fetchAll();

// --- Genres du film (N-N) ---
$reqGenres = $pdo->prepare("
    SELECT g.nom
    FROM film_genre fg
    JOIN genres g ON g.id = fg.id_genre
    WHERE fg.id_film = ?
");
$reqGenres->execute([$id]);
$genres = $reqGenres->fetchAll();

$titrePage = $film['titre'];
require "includes/header.php";
?>

<a class="back" href="index.php">← Retour à l'affiche</a>

<section class="hero">
    <?= affiche($film) ?>

    <div class="hero-info">
        <h1><?= htmlspecialchars($film['titre']) ?>
            <span class="year">(<?= (int)$film['annee'] ?>)</span></h1>

        <?= etoiles($film['note'] !== null ? (float)$film['note'] : null) ?>

        <div class="pills">
            <?php foreach ($genres as $g): ?>
                <span class="pill"><?= htmlspecialchars($g['nom']) ?></span>
            <?php endforeach; ?>
        </div>

        <p class="synopsis">
            <?= $film['synopsis'] ? nl2br(htmlspecialchars($film['synopsis'])) : "Synopsis non disponible." ?>
        </p>

        <div class="facts">
            <div class="f">
                <span>Réalisateur</span>
                <strong><?= htmlspecialchars($film['real_prenom'].' '.$film['real_nom']) ?></strong>
            </div>
            <div class="f">
                <span>Nationalité</span>
                <strong><?= htmlspecialchars($film['nationalite'] ?? '—') ?></strong>
            </div>
            <div class="f">
                <span>Durée</span>
                <strong><?= (int)$film['duree'] ?> min</strong>
            </div>
            <div class="f">
                <span>Budget</span>
                <strong><?= $film['budget'] ? number_format($film['budget'], 0, ',', ' ').' $' : '—' ?></strong>
            </div>
            <div class="f">
                <span>Recette</span>
                <strong><?= $film['recette'] ? number_format($film['recette'], 0, ',', ' ').' $' : '—' ?></strong>
            </div>
        </div>

        <a class="btn btn-danger" href="supprimer.php?id=<?= $id ?>"
           onclick="return confirm('Supprimer définitivement ce film ?');">Supprimer ce film</a>
    </div>
</section>

<h2 class="section-h">Casting</h2>
<?php if ($acteurs): ?>
    <div class="cast-grid">
        <?php foreach ($acteurs as $a): ?>
            <div class="cast-item">
                <div class="name"><?= htmlspecialchars($a['prenom'].' '.$a['nom']) ?></div>
                <div class="role"><?= htmlspecialchars($a['role'] ?? '') ?></div>
            </div>
        <?php endforeach; ?>
    </div>
<?php else: ?>
    <p>Aucun acteur enregistré pour ce film.</p>
<?php endif; ?>

<?php require "includes/footer.php"; ?>
