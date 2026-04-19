# 📂 Kids Hero Playground 目錄架構規劃

為了解決長期開發的維護性，本專案採用 **「模組化平鋪」** 與 **「資源集中化」** 架構：

## 1. 核心程式碼 (`src/`)
- `src/index.html` : **[總入口]** 遊戲樂園主選單 (Hub)，支援雙人面對面佈局。
- `src/common/` : 存放全域通用的 UI 邏輯。
  - `index.html` : 英雄挑戰賽的歡迎頁 (原 twins-game.html)。
  - `history.html` : 全局歷史紀錄查詢頁。
  - `css/global.css` : 統一的設計語言、按鈕樣式與動畫定義。
  - `js/history.js` : LocalStorage 數據管理核心。
- `src/games/` : **[遊戲模組區]** 每個新遊戲擁有獨立資料夾。
  - `hero-challenge/` : 奧特曼 x 美樂蒂 英雄挑戰賽 (Day 1)。
  - `fruit-hunt/` : 水果捉迷藏 (Day 2 - 建設中)。

## 2. 靜態資源 (`assets/`)
- `assets/common/` : 存放標誌 (`logo.png`)、全域背景圖等。
- `assets/skills/` : 專用的技能按鈕與遮蔽特效素材。
- `assets/sfx/` : 統一管理音效與背景音樂。
- `assets/games/` : 各遊戲專屬的圖像資產。
  - `hero-challenge/` : 奧特曼與美樂蒂的 PNG 圖像。

## 3. 文件紀錄 (`docs/`)
- `docs/plans/` : 一週開發時程計畫書。
- `docs/spec.md` : 技術規格總覽。
- `docs/memory.md` : 核心開發經驗與 Claude CLI 審查紀錄。

---
*此架構由「第零區架構師」Jay 規劃，旨在確保 7 天開發過程中的資源不衝突且路徑清晰。*
