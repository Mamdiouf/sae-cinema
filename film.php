<?php
// Fiche d'un film
require "db.php";
require "includes/fonctions.php";

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// film + realisateur + fiche technique + livre
$req = $pdo->prepare("
    SELECT f.titre, f.annee, f.duree, f.affiche, f.note, f.id_realisateur AS real_id,
           r.nom AS real_nom, r.prenom AS real_prenom, r.nationalite,
           ft.budget, ft.recette, ft.synopsis,
           ft.themes, ft.analyse, ft.message, ft.questions,
           l.titre AS livre_titre, l.auteur AS livre_auteur
    FROM films f
    JOIN realisateurs r            ON r.id = f.id_realisateur
    LEFT JOIN fiches_techniques ft ON ft.id_film = f.id
    LEFT JOIN livres l             ON l.id = f.id_livre
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

// acteurs du film
$reqActeurs = $pdo->prepare("
    SELECT a.prenom, a.nom, c.role
    FROM casting c
    JOIN acteurs a ON a.id = c.id_acteur
    WHERE c.id_film = ?
    ORDER BY a.nom
");
$reqActeurs->execute([$id]);
$acteurs = $reqActeurs->fetchAll();

// genres du film
$reqGenres = $pdo->prepare("
    SELECT g.nom
    FROM film_genre fg
    JOIN genres g ON g.id = fg.id_genre
    WHERE fg.id_film = ?
");
$reqGenres->execute([$id]);
$genres = $reqGenres->fetchAll();

// films similaires : +3 si meme realisateur, +2 par genre commun
$reqReco = $pdo->prepare("
    SELECT f2.id, f2.titre, f2.annee, f2.affiche, f2.note,
           (
             (CASE WHEN f2.id_realisateur = :rid THEN 3 ELSE 0 END)
             +
             (SELECT COUNT(*) * 2
                FROM film_genre gx
                JOIN film_genre gy ON gy.id_genre = gx.id_genre
               WHERE gx.id_film = f2.id AND gy.id_film = :cur1)
           ) AS score
    FROM films f2
    WHERE f2.id <> :cur2
    HAVING score > 0
    ORDER BY score DESC, f2.note DESC
    LIMIT 4
");
$reqReco->execute([':rid' => $film['real_id'], ':cur1' => $id, ':cur2' => $id]);
$recommandations = $reqReco->fetchAll();

$onglets = [
    'themes'    => 'Thèmes',
    'analyse'   => 'Analyse',
    'message'   => 'Message principal',
    'questions' => 'Questions de réflexion',
];

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
            <?php if (!empty($film['livre_titre'])): ?>
            <div class="f">
                <span>D'après le livre</span>
                <strong><?= htmlspecialchars($film['livre_titre']) ?></strong>
                de <?= htmlspecialchars($film['livre_auteur']) ?>
            </div>
            <?php endif; ?>
        </div>

        <a class="btn btn-danger" href="supprimer.php?id=<?= $id ?>"
           onclick="return confirm('Supprimer définitivement ce film ?');">Supprimer ce film</a>
    </div>
</section>

<style>
.analyse{ margin-top:30px; }
.analyse-acc{ background:#fff; border:1px solid #e3e3e3; border-radius:8px; padding:0 22px; }
.analyse-acc > summary{ cursor:pointer; list-style:none; padding:16px 0; font-weight:800; color:#1a1a1a; }
.analyse-acc > summary::-webkit-details-marker{ display:none; }
.analyse-acc > summary::before{ content:"\25B8  "; color:#febd02; }
.analyse-acc[open] > summary::before{ content:"\25BE  "; }
.tab-bar{ display:flex; flex-wrap:wrap; gap:2px; border-bottom:2px solid #e3e3e3; margin:8px 0 16px; }
.tab-btn{ background:none; border:none; cursor:pointer; padding:10px 16px; margin-bottom:-2px;
  font-size:.78rem; font-weight:700; text-transform:uppercase; letter-spacing:.5px;
  color:#6b6b6b; border-bottom:3px solid transparent; }
.tab-btn:hover{ color:#1a1a1a; }
.tab-btn.is-active{ color:#1a1a1a; border-bottom-color:#febd02; }
.tab-panel{ display:none; color:#333; line-height:1.65; max-width:70ch; }
.tab-panel.is-active{ display:block; }
</style>

<section class="analyse">
    <details class="analyse-acc">
        <summary>Voir l'analyse détaillée</summary>

        <div class="tabs">
            <div class="tab-bar" role="tablist">
                <?php $premier = true; foreach ($onglets as $cle => $label): ?>
                    <button type="button"
                            class="tab-btn<?= $premier ? ' is-active' : '' ?>"
                            data-tab="<?= $cle ?>"><?= $label ?></button>
                <?php $premier = false; endforeach; ?>
            </div>

            <?php $premier = true; foreach ($onglets as $cle => $label): ?>
                <div class="tab-panel<?= $premier ? ' is-active' : '' ?>" data-tab="<?= $cle ?>">
                    <?php $valeur = trim((string)($film[$cle] ?? '')); ?>
                    <?= $valeur !== '' ? nl2br(htmlspecialchars($valeur)) : '<em>Non renseigné pour ce film.</em>' ?>
                </div>
            <?php $premier = false; endforeach; ?>
        </div>
    </details>
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

<?php if ($recommandations): ?>
    <h2 class="section-h">Films similaires</h2>
    <div class="films-grid">
        <?php foreach ($recommandations as $reco): ?>
            <article class="film-card">
                <a href="film.php?id=<?= (int)$reco['id'] ?>">
                    <?= affiche($reco) ?>
                    <h3><?= htmlspecialchars($reco['titre']) ?></h3>
                </a>
                <p class="by"><?= (int)$reco['annee'] ?></p>
                <?= etoiles($reco['note'] !== null ? (float)$reco['note'] : null) ?>
            </article>
        <?php endforeach; ?>
    </div>
<?php endif; ?>

<script>
// gestion des onglets : on clique, on affiche le bon panneau
(function () {
    var barre = document.querySelector('.tab-bar');
    if (!barre) return;
    barre.addEventListener('click', function (e) {
        var bouton = e.target.closest('.tab-btn');
        if (!bouton) return;
        var cible = bouton.getAttribute('data-tab');
        var boutons = document.querySelectorAll('.tab-btn');
        for (var i = 0; i < boutons.length; i++) boutons[i].classList.remove('is-active');
        bouton.classList.add('is-active');
        var panneaux = document.querySelectorAll('.tab-panel');
        for (var j = 0; j < panneaux.length; j++) {
            panneaux[j].classList.toggle('is-active', panneaux[j].getAttribute('data-tab') === cible);
        }
    });
})();
</script>

<?php require "includes/footer.php"; ?>
