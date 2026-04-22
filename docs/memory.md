# 開發經驗記錄 (2026-04-18)

## 1. 環境與快取陷阱
- **現象**：修改 HTML 後，手機端瀏覽器始終顯示舊版。
- **解決**：在 Node.js 伺服器端 (`server.js`) 強制注入 `Cache-Control: no-store` Header。

## 2. 渲染引擎的抉擇 (Canvas vs DOM)
- **問題**：在通訊軟體 (Telegram/LINE) 內建瀏覽器中，Canvas 渲染有時會因為 WebGL 權限或層級問題導致內容不可見。
- **結論**：對於低齡兒童的「點擊類」遊戲，使用原生 `<img>` 元素配合 `setInterval` 移動位移是最穩定、最保證可見的方案。

## 3. 圖層與事件阻斷
- **學習**：`z-index` 的管理非常關鍵。Canvas 或透明圖層若未正確設定 `pointer-events`，會導致觸控事件無法穿透到目標物體。

## 4. 模型載入效能
- **優化**：手機端必須選用 `MoveNet Lightning` 模型而非 `Thunder`，且應將攝影機解析度限制在 640x480 以內，否則會造成嚴重的系統掉幀。

---

# 代碼審查記錄 (2026-04-19)

## 5. index.html RWD 視覺優化後的冗餘檢查

**審查範圍**：`index.html`（158 行）、`styles.css`

### CSS 冗餘
- **按鈕系統重疊**：`styles.css` 已定義 `.btn`、`.btn-secondary`、`.btn-danger`，但 `index.html` 的 `<style>` 區塊另外定義了 `.btn-primary`、`.btn-secondary-custom`，兩套系統各自帶有相似的 `padding`、`border-radius`、`-webkit-tap-highlight-color: transparent` 等規則。建議統一至 `styles.css`，`index.html` 僅引用。
- **未使用的 CSS**：`styles.css` 中的 `.winner-ultraman`、`.winner-melody`、`.winner-tie`、`.history-table` 系列規則未在 `index.html` 中使用；勝者標籤改由 JS 動態注入 Tailwind 行內類取代，舊規則可清除。
- **Tailwind 與手寫 CSS 混用**：部分間距、顏色改用 Tailwind utility class，另一部分仍保留手寫 CSS，可考慮擇一統一以降低維護成本。

### JavaScript 冗餘
- `formatTimestamp()` 與 `loadHistory()` 由外部 `history.js` 提供，`index.html` 直接呼叫但無 guard（若 `history.js` 載入失敗會靜默出錯）。建議加上 `typeof` 檢查或 `try/catch`。
- 勝者標籤的顏色邏輯（if/else 字串拼接）可改為查表（物件 map）以減少重複。

### 無需修改項目
- `@keyframes float` 動畫邏輯清晰，無冗餘。
- Landscape media query 邏輯正確，符合 RWD 需求。
- `.glass-card` 雖只用一次，但語意清楚，可保留。

**結論**：本次優化視覺上無明顯問題，主要技術債在於雙套按鈕系統與部分未使用的 CSS 規則，建議下一次重構時一併整理。

---

# 遊戲音訊解鎖模式 (2026-04-22)

## 6. BGM 在新頁面無法自動播放的問題

### 現象
從 `welcome.html` 跳到 `play-*.html` 後，BGM 並不會立刻響，必須等玩家「第一次點畫面」才播得出來。期間雖然計時器、掉落物件都已經開始運作，但遊戲處於靜音狀態。

### 根因
瀏覽器 autoplay policy：**`Audio.play()` 必須在「同一頁面、同一使用者手勢事件 (touchstart / mousedown / click / pointerdown)」的 call stack 內被呼叫，才允許播放**。
- `location.href` / `<a href>` 跳頁後，原先 welcome 頁的手勢授權不會帶到新頁面。
- 所以 play 頁即使 `window.onload` 裡直接 `bgm.play()`，仍會被 reject。

舊寫法讓 BGM 只在第一個 `touchstart` 事件處理器中被觸發（同時處理「打擊」邏輯），導致玩家要打到第一個物件才有聲音。

### 解法 — Tap to Start 遮罩（已套用於 hero-challenge、fruit-hunt）

**流程**：
1. 頁面載入 → 顯示 `#preloader`（載入進度條）
2. `preloadAssets()` resolve 後 → 把 preloader 內容替換為金色脈動的「TAP TO START」按鈕
3. 玩家點按鈕（`touchstart` / `click`）→ 同一個 handler 內依序執行：
   - `unlockAudio()`：在此手勢 stack 內 `bgm.play()`、順便 prime 其他 SFX（`hitSfx.play().then(pause)`）
   - 淡出 preloader
   - `init()` / `start()`：啟動計時器、spawn interval、將 `active` 設 true

**關鍵實作細節**：
- `active` 初始值必須設為 `false`，避免玩家點到 TAP TO START 按鈕時，window 層級的 `touchstart` 同時觸發 `handleHit()` 而誤加分（`handleHit` 依 `active` early-return）。
- `unlockAudio()` 要有 `audioUnlocked` guard，允許被多次呼叫（按鈕一次 + 後續 touchstart 每一次都會再呼叫，但只有第一次有效）。
- 對於遊戲結束後才播的 `endSound` / `gameOver` 等音效，也要在 `unlockAudio()` 內先做 `play().then(pause)` 的 priming，否則到 `end()` 時已沒有使用者手勢，會被 block。
- 技能按鈕的 `touchend` handler 也要呼叫 `unlockAudio()`（雖然 window 層級已有，但避免 `stopPropagation` 擋住）。

**參考實作**：
- [src/games/hero-challenge/play-solo.html](../src/games/hero-challenge/play-solo.html) — `unlockAudio()` + `showTapToStart()`
- [src/games/hero-challenge/play-duo.html](../src/games/hero-challenge/play-duo.html)
- [src/games/fruit-hunt/play.html](../src/games/fruit-hunt/play.html)

### 未來新增遊戲時的 checklist
- [ ] `var/let active = false` 初始
- [ ] `new Audio(...)` 後不要直接 `.play()`；透過 `unlockAudio()`
- [ ] `unlockAudio()` 內 prime 所有延後才要播的 SFX
- [ ] 預載完成後顯示 TAP TO START，而不是直接 `start()` / `init()`
- [ ] 視需要在 window `touchstart` / `mousedown` 也呼叫一次 `unlockAudio()` 作為保險
