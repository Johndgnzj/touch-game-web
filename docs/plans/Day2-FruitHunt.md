# 🍎 Day 2 遊戲提案：水果捉迷藏 (Fruit Hunt Adventure)

## 🎯 遊戲目標
針對 3-6 歲兒童，透過顏色與形狀辨識，訓練手眼協調與反應力。
支援 **「單人模式」** 與 **「雙人面對面合作/競賽」**。

## 🕹️ 遊戲方式 (Gameplay)
1. **核心邏輯**：畫面會隨機從不同的「神奇樹洞」跳出各種水果。
2. **任務目標**：
   - 螢幕上方會顯示「目前目標」（例如：🍎 蘋果）。
   - 孩子需要點擊正確的水果。
   - **雙人模式**：螢幕上下 180 度翻轉，兩個孩子比賽看誰先抓到指定的目標水果。
3. **獎勵機制**：連續抓對 3 次會觸發「水果狂歡 (Fruit Party)」，全螢幕噴灑水果雨，點擊可獲得加倍分數。
4. **時間限制**：每局 30 秒，挑戰最高連擊。

## 🖼️ 畫面需求 (UI/UX)
- **場景**：清新自然的森林背景，帶有微風吹動樹葉的動畫。
- **樹洞**：3(簡單)/5(困難) 個可愛的圓形樹洞，水果會從裡面縮放跳出 (Pop-up)。
- **反饋**：點對時水果會發光並彈跳，點錯時會發出悶悶的音效。
- **倒數計時**：頂部大型木製質感的計時器。

## 📂 目錄結構規劃
依照 Day 1 確立的模組化架構：
- `src/games/fruit-hunt/index.html` : 遊戲主程式
- `src/games/fruit-hunt/assets/games/fruit-hunt/` : 存放水果素材
- `src/games/fruit-hunt/assets/sfx/fruit-pop.mp3` : 點擊音效
- `src/games/fruit-hunt/assets/sfx/fruit-success.mp3` : 狂歡模式音樂

## 🎨 素材產生 (AI Prompts)
我將使用 Gemini 產生以下素材：
1. **背景圖**：`A vibrant, cartoonish enchanted forest background for a mobile game, soft sunlight filtering through trees, flat 2D vector style, 16:9 aspect ratio.`
2. **水果組**：`A set of cute chibi-style fruits (Apple, Banana, Strawberry, Grape, Watermelon) with cute faces, thick outlines, flat 2D vector art, isolated on white background.`
3. **樹洞**：`A cute wooden hollow tree hole icon, 2D game asset, flat vector style, isolated on white background.`

---

# 📅 1週進化日誌 (2026-04-20)
**今日更新內容：**
1. **架構定基**：完成了 `src/` 與 `assets/` 的全面目錄重構，建立模組化開發體系。
2. **路由修正**：修復了 Hub 導向與歷史紀錄返回的 404 問題。
3. **奧義升級**：實作了「柯博文巨大化」與「半螢幕遮蔽」技能系統，正式打通遊戲互動邏輯。
4. **性能加固**：重寫了 `server.js` 解決 MIME Type 導致的遠端樣式失效。

**明日目標：** 啟動 Claude CLI 進行 `fruit-hunt` 的代碼實作，並發佈正式版。
