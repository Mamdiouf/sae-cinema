<?php
// ============================================================
//  realisateurs.php  -  Liste des réalisateurs
//  Illustre la relation 1-N : pour chaque réalisateur,
//  on compte et on liste ses films.
// ============================================================
require "db.php";

$sql = "
    SELECT  r.id, r.nom, r.prenom, r.nationalite,
            COUNT(f.id) AS nb_films,
            GROUP_CONCAT(f.titre ORDER BY f.annee SEPARATOR ', ') AS films
    FROM realisateurs r
    LEFT JOIN films f ON f.id_realisateur = r.id
    GROUP BY r.id
    ORDER BY r.nom
";
$realisateurs = $pdo->query($sql)->fetchAll();

$titrePage = "Réalisateurs";
require "includes/header.php";
?>

<h1 class="page-title">Réalisateurs</h1>
<p class="page-sub">Un réalisateur peut signer plusieurs films — relation 1-N</p>

<table>
    <tr>
        <th>Réalisateur</th>
        <th>Nationalité</th>
        <th>Films</th>
        <th>Filmographie</th>
    </tr>
    <?php foreach ($realisateurs as $r): ?>
        <tr>
            <td><strong><?= htmlspecialchars($r['prenom'].' '.$r['nom']) ?></strong></td>
            <td><?= htmlspecialchars($r['nationalite'] ?? '—') ?></td>
            <td><?= (int)$r['nb_films'] ?></td>
            <td><?= htmlspecialchars($r['films'] ?? '—') ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<?php require "includes/footer.php"; ?>
