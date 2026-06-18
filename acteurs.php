<?php
// Liste des acteurs et de leurs films (relation N-N)
require "db.php";

$sql = "
    SELECT  a.id, a.nom, a.prenom,
            COUNT(c.id_film) AS nb_films,
            GROUP_CONCAT(f.titre ORDER BY f.titre SEPARATOR ', ') AS films
    FROM acteurs a
    LEFT JOIN casting c ON c.id_acteur = a.id
    LEFT JOIN films f   ON f.id = c.id_film
    GROUP BY a.id
    ORDER BY a.nom
";
$acteurs = $pdo->query($sql)->fetchAll();

$titrePage = "Acteurs";
require "includes/header.php";
?>

<h1 class="page-title">Acteurs</h1>
<p class="page-sub">Un acteur peut apparaître dans plusieurs films — relation N-N</p>

<table>
    <tr>
        <th>Acteur</th>
        <th>Films</th>
        <th>Apparaît dans</th>
    </tr>
    <?php foreach ($acteurs as $a): ?>
        <tr>
            <td><strong><?= htmlspecialchars($a['prenom'].' '.$a['nom']) ?></strong></td>
            <td><?= (int)$a['nb_films'] ?></td>
            <td><?= htmlspecialchars($a['films'] ?? '—') ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<?php require "includes/footer.php"; ?>
