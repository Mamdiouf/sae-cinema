<?php
// Suppression d'un film (les données liées partent en cascade)
require "db.php";

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id > 0) {
    $req = $pdo->prepare("DELETE FROM films WHERE id = ?");
    $req->execute([$id]);
}

header("Location: index.php?ok=1");
exit;
