<?php
// fonctions d'affichage (étoiles, affiche)

// note (ex 4.7) -> étoiles
function etoiles(?float $note): string {
    if ($note === null) {
        return '<span class="stars empty">☆☆☆☆☆</span>';
    }
    $pleines = (int) round($note);
    $vides   = 5 - $pleines;
    $html  = '<span class="stars">';
    $html .= str_repeat('★', $pleines);
    $html .= '<span class="empty">' . str_repeat('☆', $vides) . '</span>';
    $html .= '</span>';
    return $html;
}

// affiche du film ; si l'image est cassée on garde le titre sur fond coloré
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
        $html .= '<img src="' . htmlspecialchars($url) . '" alt="Affiche de ' . $titre . '"'
               . ' onerror="this.style.display=\'none\'">';
    }
    $html .= '</div>';
    return $html;
}
