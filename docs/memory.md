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
