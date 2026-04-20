/**
 * Kids Hero Playground - Unified History System
 */
const STORAGE_KEY = 'kids-hero-history-v2';

function saveRecord(data) {
    let history = loadFullHistory();
    const entry = {
        id: Date.now(),
        date: new Date().toISOString(),
        game: data.game || 'hero-challenge',
        score: data.score || 0,
        scores: data.scores || null, // For duo mode
        winner: data.winner || null,
        mode: data.mode || 'solo'
    };
    history.unshift(entry);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(history.slice(0, 50)));
}

function loadFullHistory() {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
}

// Backward compatibility for hero-challenge
function saveRecordLegacy(s1, s2) {
    saveRecord({
        game: 'hero-challenge',
        scores: { u: s1, m: s2 },
        winner: s1 > s2 ? 'ultraman' : s2 > s1 ? 'melody' : 'tie',
        mode: 'duo'
    });
}
