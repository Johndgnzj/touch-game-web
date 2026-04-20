# Kids Hero Play - 全球一體化目錄結構 (2026-04-20)

所有開發內容已從 ai-hero-platform 整合回 touch-game-web。

## 目錄結構
- `/src` - 原始碼
  - `/index.html` - 全球門戶入口
  - `/games` - 遊戲模組
    - `/hero-challenge` - 奧特曼 x 美樂蒂 (整合 main2 邏輯)
  - `/news` - 早報觀測站 (包含 46 份物理靜態頁面)
- `/assets` - 統一資產庫
  - `/common` - 公用背景、Logo
  - `/games` - 遊戲專用圖片
  - `/sfx` - 音效庫
- `/docs` - 規劃與紀錄

## 部署流程
- 執行 `auto_deploy_all.sh` 將 src 內容推送到 Firebase。
