<?php
// ============================================================
//  db.php  -  Connexion a la base de donnees avec PDO
//  Ce fichier est inclus (require) par toutes les pages.
// ============================================================

$host   = "localhost";   // serveur MySQL (MAMP)
$dbname = "cinema";       // nom de notre base
$user   = "root";         // identifiant MAMP par defaut
$pass   = "root";         // mot de passe MAMP par defaut

try {
    // Creation de l'objet PDO = la connexion
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $user,
        $pass
    );

    // En cas d'erreur SQL, PDO lancera une exception (plus facile a debugger)
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Les resultats seront recuperes sous forme de tableaux associatifs
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    // Si la connexion echoue, on arrete tout et on affiche l'erreur
    die("Erreur de connexion a la base : " . $e->getMessage());
}
