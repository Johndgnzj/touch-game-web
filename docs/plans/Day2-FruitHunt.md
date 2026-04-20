# 🍎 Day 2 遊戲提案：水果捉迷藏 (Fruit Hunt Adventure)

> 沿用 Day 1 `hero-challenge/` 已驗證的模組化架構：
> `welcome.html`（簡報 / 設定）→ 遊戲主程式 → in-page 結算覆蓋層；
> URL 參數驅動、純靜態、CDN Tailwind、`../../common/` 共享資源。

---

## 1. 概要 (Concept)

| 項目 | 內容 |
|---|---|
| **目標族群** | 3–6 歲兒童，重點：顏色與形狀辨識、手眼協調、反應力 |
| **語言原則** | 遊戲畫面內 **全程以圖示/英文/數字呈現**，避免中文（小朋友尚未識字） |
| **使用情境** | 家長手機（單人）或平板（雙人面對面） |
| **時長** | 一局 30 / 45 / 60 秒可選；中位約 30 秒一輪 |
| **一致性** | 視覺與 UX 與 [hero-challenge/welcome.html](../../src/games/hero-challenge/welcome.html) 連貫，但配色從「藍 × 粉 霓虹」轉為「森林綠 × 陽光黃」自然調 |

---

## 2. 玩法 (Gameplay)

### 2.1 核心邏輯
1. 畫面顯示 **3 個（簡單）或 5 個（困難）** 圓形樹洞。
2. 樹洞會以 **隨機間隔（1.0 ~ 1.6s）** 跳出一顆水果，停留 **0.9 ~ 1.4s** 後縮回。
3. 螢幕頂部顯示 **本回合目標水果（圖 + 顏色色塊）**，例如：🍎 紅蘋果。
4. 玩家點擊「正確的目標水果」→ 得分 + 連擊累加；點到其他水果 → 連擊歸零、扣 0 分（不扣分但中斷 combo，避免挫折）。

### 2.2 模式 (`?mode=`)

| 模式 | 值 | 畫面 |
|---|---|---|
| **單人 Solo** | `solo`（預設） | 全螢幕一個視角，目標列在頂端 |
| **雙人 Duel** | `duo` | 沿用 [main2.html](../../src/games/hero-challenge/main2.html) 的 `half-left` / `half-right` + 旋轉 90° 結構，左右兩半各自顯示 3/5 個樹洞與獨立分數，**共享同一目標水果** |

### 2.3 難度 (`?level=`)
| 值 | 樹洞數 | 同時最多水果數 | 干擾水果種類 |
|---|---|---|---|
| `easy` | 3 | 1 | 3 種（含目標） |
| `hard` | 5 | 2 | 5 種（含目標） |

### 2.4 時長 (`?time=`)
與 hero-challenge 同一套白名單：`30 / 45 / 60`，預設 `30`。

### 2.5 計分與連擊
- 正確點擊：`+1` 分；`combo += 1`
- 錯誤點擊：`+0` 分；`combo = 0`；播放悶悶 `wrong.mp3`
- 連擊每達 `3` 整數倍 → 觸發 **Fruit Party**

### 2.6 Fruit Party 狂歡
- 觸發後 **3 秒**內，全螢幕從上方降下 20 ~ 30 顆水果雨（與目標無關）
- 期間任意水果點擊 = `+2` 分（雙倍）
- 期間連擊邏輯暫停（不扣 combo）
- 結束時平滑淡出，回到主迴圈

### 2.7 結束條件
時間歸零 → 顯示 in-page 結算覆蓋層（樣式參考 [main2.html#L142-L162](../../src/games/hero-challenge/main2.html#L142)）：
- Solo：總分、最大連擊、命中率
- Duo：兩側分數比較 + Winner 標示（與 hero-challenge `#winner-msg` 一致樣式）
- 按鈕：`RESTART`（reload）/ `MENU`（→ `../index.html`）

---

## 3. 畫面流程 (Screen Flow)

```
src/games/index.html  (Mission Select)
        │  點「水果捉迷藏」卡
        ▼
src/games/fruit-hunt/welcome.html    ← 簡報：選 mode / level / time
        │  點 ENTER FOREST
        ▼
src/games/fruit-hunt/play.html?mode=&level=&time=    ← 遊戲主程式
        │  時間到
        ▼
in-page 結算覆蓋層 → RESTART / MENU
```

> 命名 `play.html` 而非 `main2.html`，因為 fruit-hunt 在 solo 模式下並非雙螢幕分割；雙人模式靠 `?mode=duo` 切換 layout。

---

## 4. UI / 視覺規範

### 4.1 沿用 [welcome.html](../../src/games/hero-challenge/welcome.html) 的設計語言
- **字體**：`Bungee`（英文標題）+ `M PLUS Rounded 1c`（中文）+ `JetBrains Mono`（HUD 數字）
- **語彙**：glass card、conic-gradient 旋轉邊框、四角 L 型標、staggered reveal `d-1 ~ d-6`、CTA sheen 掃光

### 4.2 主題差異（從 hero 轉森林）
| 元素 | hero-challenge | fruit-hunt |
|---|---|---|
| 主色 | 藍 `#3b82f6` × 粉 `#ec4899` | 葉綠 `#22c55e` × 陽光 `#fbbf24` |
| 背景 | nebula + 星空 + 掃描線 | 森林晨霧（漸層）+ 散景光斑 + 微飄落葉粒子（CSS-only） |
| 強調 | 霓虹輝光 | 暖陽 drop-shadow + 木質紋理 hint |

### 4.3 HUD 元素
- **頂端目標卡**：顯示當前目標水果（大圖 + 名稱英文 + 顏色色塊），有 `pulse` 光暈呼吸動畫
- **左上**：時間（圓形大數字 + 5 秒內 `timer-danger` shake）
- **右上**：連擊計數 + COMBO 條（達 3 變金色）
- **底部**：分數（duo 模式：左右各一）

### 4.4 樹洞 Pop 動畫
- 跳出：`transform: scale(0)` → `scale(1.1)` → `scale(1)`，搭配 `cubic-bezier(0.34, 1.56, 0.64, 1)`
- 命中：水果 `scale(1.4) + 金色 ring` 0.2s 後消失
- 錯誤命中：水果輕微抖動 + 紅 flash

---

## 5. 目錄結構

依 Day 1「**用在哪個子專案就放在那裡**」原則，每個遊戲自帶 `assets/`：

```
src/games/fruit-hunt/
├── welcome.html              # 簡報 / 設定（mode/level/time 三選一）
├── play.html                 # 遊戲主程式（讀 ?mode= ?level= ?time=）
└── assets/
    ├── background.jpg        # 森林晨霧背景
    ├── tree-hole.png         # 樹洞圖（共用一張）
    ├── fruits/
    │   ├── apple.png
    │   ├── banana.png
    │   ├── strawberry.png
    │   ├── grape.png
    │   └── watermelon.png
    └── sfx/
        ├── pop.mp3           # 樹洞跳出
        ├── hit.mp3           # 命中正確
        ├── wrong.mp3         # 點到錯的（悶音）
        ├── party.mp3         # Fruit Party 觸發
        └── bgm.mp3           # 輕快背景樂（loop）
```

> ⚠️ 修正：原稿寫 `src/games/fruit-hunt/assets/games/fruit-hunt/` 多了一層 `games/fruit-hunt/`，是 Day 1 重構前的舊路徑遺跡，扁平化即可。

### 5.1 共享資源（不重複）
- `../../common/css/global.css`（如有共用樣式）
- `../../common/js/history.js`（**需擴充支援多遊戲**，見 §8）
- 不再自帶 `logo.png`：fruit-hunt 在 mission select 用 emoji 或自製圖示即可，避免再產一張

---

## 6. URL 參數 API

| 參數 | 值 | 預設 | 備註 |
|---|---|---|---|
| `time` | `30` / `45` / `60` | `30` | 與 hero-challenge 同一套白名單 |
| `mode` | `solo` / `duo` | `solo` | duo = 上下鏡像佈局 |
| `level` | `easy` / `hard` | `easy` | 影響樹洞數與干擾水果 |

**範例**：`play.html?time=45&mode=duo&level=hard`

驗證模式同 [main2.html#L222-L227](../../src/games/hero-challenge/main2.html#L222)：白名單比對，非法值 fallback 預設。

---

## 7. welcome.html 簡報設計（複用既有 pattern）

直接複製 [hero-challenge/welcome.html](../../src/games/hero-challenge/welcome.html) 的 layout DNA，只置換內容：

- **Topbar**：左「← BACK TO MISSIONS」(→ `../index.html`)、右 `[ FOREST · 02 ]` HUD tag
- **標題**：`READY TO HUNT` + 副標 `Fruit Hunt Adventure · 水果捉迷藏`
- **設定面板（取代原 faceoff）**：垂直三段
  1. **MODE**：兩格切換 `SOLO 🧒` / `DUO 🧒🧒`
  2. **DIFFICULTY**：兩格切換 `EASY 3🌳` / `HARD 5🌳`
  3. **MATCH LENGTH**：三格 `30 / 45 / 60` Sprint / Standard / Marathon（與 hero-challenge 完全一致的 `.time-option` 元件）
- **CTA**：金色按鈕 `ENTER FOREST ➜`，`href` 動態組合三個參數
- **規則條**：3 卡 — `TAP THE TARGET` / `CHAIN COMBOS` / `FRUIT PARTY`

> 實作時：把 hero 的 `.time-option` 元件抽象為通用 `.choice-option`，三段設定都用同一套樣式，避免重複 CSS。

---

## 8. 與既有系統整合

### 8.1 Mission Select 卡片
更新 [src/games/index.html](../../src/games/index.html) 第二格（目前是「Coming Soon」鎖卡）：
- 解鎖：移除 `card-locked` / 掛鎖 SVG
- 連結 → `./fruit-hunt/welcome.html`
- 主色換為森林綠 conic-gradient
- 標題 `FRUIT HUNT` / 中文 `水果捉迷藏` / 標籤 `Family · Solo or Duo`

### 8.2 history.js 擴充
目前 [history.js](../../src/common/js/history.js) 寫死 `s1/s2/winner: ultraman|melody|tie`，是 hero-challenge 專屬。為支援 fruit-hunt 紀錄需擴充：

```js
// 建議新 API（向後相容）
saveRecord({
  game: 'fruit-hunt',          // or 'hero-challenge'
  mode: 'solo' | 'duo',
  scores: { left: 12, right: 9 },   // solo 時只用 left
  combo: 7,
  durationSec: 45,
  level: 'easy'
});
```

舊 `saveRecord(s1, s2)` 包成 thin wrapper 呼叫新 API，避免改壞 hero-challenge。

### 8.3 結算頁複用
in-page 結算覆蓋層直接抄 [main2.html#L198-L218](../../src/games/hero-challenge/main2.html#L198) 的 `#result` 區塊，把頭像換成「目標水果獎盃」即可。

---

## 9. 素材產生 (AI Prompts)

| 檔名 | Prompt |
|---|---|
| `assets/background.jpg` | `A vibrant cartoonish enchanted forest background, soft sunlight filtering through trees, flat 2D vector style, 16:9 landscape, no characters, suitable for game backdrop` |
| `assets/tree-hole.png` | `A cute wooden hollow tree hole front-facing, dark interior, 2D game asset, flat vector, isolated on transparent background, square 1:1` |
| `assets/fruits/*.png` | `A cute chibi-style {apple/banana/strawberry/grape/watermelon} with a smiling face, thick outlines, flat 2D vector, isolated on transparent background, square 1:1, vibrant saturated colors` |

音效以 [zapsplat.com](https://www.zapsplat.com/) 或 freesound 取材：
- `pop.mp3`：木質「咚」短音
- `hit.mp3`：清亮鈴鐺 + chime
- `wrong.mp3`：悶悶低頻
- `party.mp3`：Lo-Fi 派對小號
- `bgm.mp3`：輕快 ukulele loop, BPM ~ 110

---

## 10. 驗收條件 (Acceptance Criteria)

純靜態檢驗：

1. `open src/games/index.html` → 第二格已是「FRUIT HUNT」可點，導向 `./fruit-hunt/welcome.html`
2. welcome.html：
   - [ ] 切換三段設定（mode / level / time）→ active 狀態正確、CTA `href` 即時更新對應 query string
   - [ ] 「← BACK TO MISSIONS」回到 `../index.html`
3. play.html：
   - [ ] `?level=easy` → 3 樹洞；`?level=hard` → 5 樹洞
   - [ ] `?mode=duo` → 上下鏡像、雙分數
   - [ ] `?time=60` → 計時器初始顯示 60，同步到所有時間 UI
   - [ ] 連續答對 3 次 → Fruit Party 觸發 3 秒
   - [ ] 時間歸零 → 結算覆蓋層出現，按鈕可用
4. DevTools Network 面板無 404；`grep -rn "\.\./\.\./\.\./assets" src/games/fruit-hunt/` 應為空
5. 全程遊戲畫面無中文文字（target 名稱用英文 `APPLE` / `BANANA`...）

---

## 11. 不在本次範圍

- 多語系切換（目前語言原則：UI 全英 + 簡報雙語）
- 線上排行榜（仍走 localStorage `history.js`）
- 進階特效如粒子物理引擎（CSS keyframes 已足夠 3–6 歲族群感受）
- 遊戲外配色主題切換（後續若加白晝/夜晚版再處理）

---

# 📅 1週進化日誌 (2026-04-20)

**今日更新內容：**
1. **架構定基**：完成了 `src/` 與 `assets/` 的全面目錄重構，建立模組化開發體系。
2. **路由修正**：修復了 Hub 導向與歷史紀錄返回的 404 問題。
3. **奧義升級**：實作了「柯博文巨大化」與「半螢幕遮蔽」技能系統，正式打通遊戲互動邏輯。
4. **性能加固**：重寫了 `server.js` 解決 MIME Type 導致的遠端樣式失效。
5. **體驗升級**：重設計 `games/index.html` Mission Select 與 `hero-challenge/welcome.html` 對戰簡報，導入 `?time=` 參數讓玩家自選 30 / 45 / 60 秒。

**明日目標：** 啟動 Claude CLI 進行 `fruit-hunt` 的代碼實作，並發佈正式版。
