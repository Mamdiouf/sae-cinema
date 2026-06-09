<?php
// En-tête commun à toutes les pages.
// $titrePage peut être défini avant l'inclusion pour changer le titre de l'onglet.
if (!isset($titrePage)) {
    $titrePage = "Cinémathèque";
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($titrePage) ?> — Cinémathèque</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <header class="topbar">
        <div class="topbar-inner">
            <a class="logo" href="index.php"><b>CINÉ</b>mathèque</a>
            <nav>
                <a href="index.php">Films</a>
                <a href="realisateurs.php">Réalisateurs</a>
                <a href="acteurs.php">Acteurs</a>
                <a href="ajouter.php" class="cta">+ Ajouter un film</a>
            </nav>
        </div>
    </header>
    <main class="container">
