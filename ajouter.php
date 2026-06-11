<?php
// ============================================================
//  ajouter.php  -  Formulaire d'ajout d'un film
//  Montre les INSERT en PDO avec requêtes préparées,
//  une TRANSACTION (film + fiche + genres en une seule fois)
//  et l'écriture dans une table N-N (film_genre).
// ============================================================
require "db.php";

$realisateurs = $pdo->query("SELECT id, nom, prenom FROM realisateurs ORDER BY nom")->fetchAll();
$genres       = $pdo->query("SELECT id, nom FROM genres ORDER BY nom")->fetchAll();

$erreur = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $titre          = trim($_POST['titre'] ?? '');
    $annee          = (int)($_POST['annee'] ?? 0);
    $duree          = (int)($_POST['duree'] ?? 0);
    $id_realisateur = (int)($_POST['id_realisateur'] ?? 0);
    $affiche        = trim($_POST['affiche'] ?? '');
    $note           = ($_POST['note'] ?? '') !== '' ? (float)$_POST['note'] : null;
    $synopsis       = trim($_POST['synopsis'] ?? '');
    $budget         = ($_POST['budget'] ?? '') !== '' ? (int)$_POST['budget'] : null;
    $genresChoisis  = $_POST['genres'] ?? [];

    if ($titre === '' || $id_realisateur === 0) {
        $erreur = "Le titre et le réalisateur sont obligatoires.";
    } else {
        try {
            $pdo->beginTransaction();

            // 1) Film (relation 1-N vers le réalisateur)
            $req = $pdo->prepare("
                INSERT INTO films (titre, annee, duree, affiche, note, id_realisateur)
                VALUES (?, ?, ?, ?, ?, ?)
            ");
            $req->execute([$titre, $annee ?: null, $duree ?: null, $affiche ?: null, $note, $id_realisateur]);
            $idFilm = $pdo->lastInsertId();

            // 2) Fiche technique (relation 1-1)
            $req = $pdo->prepare("
                INSERT INTO fiches_techniques (id_film, budget, synopsis)
                VALUES (?, ?, ?)
            ");
            $req->execute([$idFilm, $budget, $synopsis ?: null]);

            // 3) Genres (relation N-N)
            $reqG = $pdo->prepare("INSERT INTO film_genre (id_film, id_genre) VALUES (?, ?)");
            foreach ($genresChoisis as $idGenre) {
                $reqG->execute([$idFilm, (int)$idGenre]);
            }

            $pdo->commit();
            header("Location: index.php?ok=1");
            exit;

        } catch (PDOException $e) {
            $pdo->rollBack();
            $erreur = "Erreur lors de l'enregistrement : " . $e->getMessage();
        }
    }
}

$titrePage = "Ajouter un film";
require "includes/header.php";
?>

<h1 class="page-title">Ajouter un film</h1>
<p class="page-sub">Le film, sa fiche technique et ses genres sont enregistrés ensemble (transaction)</p>

<?php if ($erreur): ?>
    <div class="alert error"><?= htmlspecialchars($erreur) ?></div>
<?php endif; ?>

<form class="box" method="post" action="ajouter.php">
    <label for="titre">Titre *</label>
    <input type="text" id="titre" name="titre" required>

    <label for="annee">Année</label>
    <input type="number" id="annee" name="annee" min="1900" max="2100">

    <label for="duree">Durée (minutes)</label>
    <input type="number" id="duree" name="duree" min="1">

    <label for="id_realisateur">Réalisateur *</label>
    <select id="id_realisateur" name="id_realisateur" required>
        <option value="">— Choisir —</option>
        <?php foreach ($realisateurs as $r): ?>
            <option value="<?= (int)$r['id'] ?>">
                <?= htmlspecialchars($r['prenom'].' '.$r['nom']) ?>
            </option>
        <?php endforeach; ?>
    </select>

    <label for="affiche">URL de l'affiche</label>
    <input type="url" id="affiche" name="affiche" placeholder="https://...">

    <label for="note">Note (sur 5)</label>
    <input type="number" id="note" name="note" min="0" max="5" step="0.1">

    <label for="budget">Budget ($)</label>
    <input type="number" id="budget" name="budget" min="0">

    <label for="synopsis">Synopsis</label>
    <textarea id="synopsis" name="synopsis" rows="3"></textarea>

    <label>Genres</label>
    <div class="checks">
        <?php foreach ($genres as $g): ?>
            <label>
                <input type="checkbox" name="genres[]" value="<?= (int)$g['id'] ?>">
                <?= htmlspecialchars($g['nom']) ?>
            </label>
        <?php endforeach; ?>
    </div>

    <p><button type="submit" class="btn">Enregistrer le film</button></p>
</form>

<?php require "includes/footer.php"; ?>
