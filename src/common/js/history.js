var HISTORY_KEY = 'touch-game-history';
var MAX_RECORDS = 50;

function loadHistory() {
    try {
        return JSON.parse(localStorage.getItem(HISTORY_KEY)) || [];
    } catch (e) {
        return [];
    }
}

function saveRecord(s1, s2) {
    var records = loadHistory();
    records.unshift({
        timestamp: Date.now(),
        s1: s1,
        s2: s2,
        winner: computeWinner(s1, s2)
    });
    if (records.length > MAX_RECORDS) records.length = MAX_RECORDS;
    localStorage.setItem(HISTORY_KEY, JSON.stringify(records));
}

function clearHistory() {
    localStorage.removeItem(HISTORY_KEY);
}

function computeWinner(s1, s2) {
    if (s1 > s2) return 'ultraman';
    if (s2 > s1) return 'melody';
    return 'tie';
}

function formatTimestamp(ts) {
    return new Date(ts).toLocaleString();
}
