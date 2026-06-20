<?php
// Liste des livres et de leurs adaptations (relation 1-N)
require "db.php";

$sql = "
    SELECT  l.id, l.titre, l.auteur, l.annee, l.programme,
            COUNT(f.id) AS nb_films,
            GROUP_CONCAT(f.titre ORDER BY f.annee SEPARATOR ', ') AS films
    FROM livres l
    LEFT JOIN films f ON f.id_livre = l.id
    GROUP BY l.id
    ORDER BY l.programme, l.titre
";
$livres = $pdo->query($sql)->fetchAll();

$titrePage = "Livres";
require "includes/header.php";
?>

<h1 class="page-title">Livres adaptés au cinéma</h1>
<p class="page-sub">Un livre peut donner plusieurs adaptations — relation 1-N</p>

<table>
    <tr>
        <th>Livre</th>
        <th>Auteur</th>
        <th>Année</th>
        <th>Programme</th>
        <th>Adaptation(s)</th>
    </tr>
    <?php foreach ($livres as $l): ?>
        <tr>
            <td><strong><?= htmlspecialchars($l['titre']) ?></strong></td>
            <td><?= htmlspecialchars($l['auteur']) ?></td>
            <td><?= (int)$l['annee'] ?></td>
            <td><?= htmlspecialchars($l['programme'] ?? '—') ?></td>
            <td><?= htmlspecialchars($l['films'] ?? '—') ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<?php require "includes/footer.php"; ?>
