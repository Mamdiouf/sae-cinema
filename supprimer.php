<?php
// ============================================================
//  supprimer.php  -  Supprime un film
//  Grace au "ON DELETE CASCADE" defini dans le schema SQL,
//  la fiche technique, le casting et les genres lies
//  sont supprimes automatiquement.
// ============================================================
require "db.php";

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id > 0) {
    $req = $pdo->prepare("DELETE FROM films WHERE id = ?");
    $req->execute([$id]);
}

// Retour a l'accueil
header("Location: index.php?ok=1");
exit;
