# Kids Hero Play - 全球一體化目錄結構 (2026-04-20)

所有開發內容已從 ai-hero-platform 整合回 touch-game-web。資源檔案採「**就近原則**」收納於各子專案內部，避免跨層 `../../../` 引用。

## 目錄結構
- `/src` - 原始碼
  - `/index.html` - 全球門戶入口
  - `/common` - 跨子專案共用的 UI 與遊戲標題畫面
    - `/index.html` - 遊戲標題畫面（Start Mission 入口）
    - `/history.html` - 戰績歷史頁
    - `/css/global.css` - 共用樣式（按鈕、history table）
    - `/js/history.js` - 戰績讀寫
  - `/games` - 遊戲模組
    - `/hero-challenge` - 奧特曼 x 美樂蒂
      - `main2.html` - 主版（雙人平板對戰，使用中）
      - `game.html` - 替代版（單畫面）
      - `welcome.html`、`index.html` - 進場頁面
      - `/assets` - **本遊戲專屬資源**（背景、logo、角色、技能、音效）
        - `background-portrait.jpg`、`background-landscape.jpg`
        - `logo.png`
        - `ultraman.png`、`melody.png`
        - `/skills` - kuromi/spiderman 的 block/skill 圖
        - `/sfx` - bgm、hit、gameover
  - `/news` - 早報觀測站（46 份物理靜態頁面，純 CDN 樣式，無本地資源）
- `/docs` - 規劃與紀錄

## 資源放置原則
- 每個子專案在其根目錄下持有自己的 `assets/`，引用一律使用同層相對路徑 `assets/<file>`。
- 禁止 `../../../assets` 形式的跨層引用；確需跨子專案引用（例如 common 引用遊戲 logo），最多一層 `..`。
- 共用資源優先放在「實際使用者」所在的子專案；若真有多處共用，再評估上提至 `common/assets/`。

## 部署流程
- 執行 `auto_deploy_all.sh` 將 src 內容推送到 Firebase。
