<?php
// ============================================================
//  fonctions.php  -  Petites fonctions d'affichage réutilisables
// ============================================================

/**
 * Affiche une note sous forme d'étoiles (sur 5).
 * Exemple : 4.7  ->  ★★★★★ (4 pleines + 1 selon arrondi)
 */
function etoiles(?float $note): string {
    if ($note === null) {
        return '<span class="stars empty">☆☆☆☆☆</span>';
    }
    $pleines = (int) round($note);          // arrondi à l'étoile la plus proche
    $vides   = 5 - $pleines;
    $html  = '<span class="stars">';
    $html .= str_repeat('★', $pleines);
    $html .= '<span class="empty">' . str_repeat('☆', $vides) . '</span>';
    $html .= '</span>';
    return $html;
}

/**
 * Affiche le bloc "affiche" d'un film.
 * Si l'image ne charge pas (URL cassée), on retombe sur un fond
 * dégradé avec le titre écrit dessus.
 */
function affiche(array $film): string {
    $titre = htmlspecialchars($film['titre']);
    $url   = $film['affiche'] ?? '';
    $note  = isset($film['note']) ? (float)$film['note'] : null;

    $html  = '<div class="poster">';
    if ($note !== null) {
        $html .= '<span class="note-badge">★ ' . number_format($note, 1, ',', '') . '</span>';
    }
    $html .= '<span class="fallback">' . $titre . '</span>';
    if ($url !== '') {
        // onerror : si l'image est introuvable, on la masque (le fallback réapparaît)
        $html .= '<img src="' . htmlspecialchars($url) . '" alt="Affiche de ' . $titre . '"'
               . ' onerror="this.style.display=\'none\'">';
    }
    $html .= '</div>';
    return $html;
}
