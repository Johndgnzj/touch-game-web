# 奧特曼 x 美樂蒂：英雄挑戰賽 (Ultraman x Melody Touch Game)

## 1. 遊戲流程
- **歡迎畫面**：標題、開始按鈕、歷史紀錄(LocalStorage)。
- **模式選擇**：AI 肢體感應模式 (Pose Detection) vs 純觸控模式 (Touch Only)。
- **遊戲進行**：
  - 限時 30 秒倒數。
  - 左側奧特曼：捕捉怪獸 (👾)。
  - 右側美樂蒂：捕捉草莓 (🍓)。
- **結算畫面**：顯示雙方最終得分與角色圖像。

## 2. 技術規格
- **前端**：單頁 HTML + Tailwind CSS + 原生 JavaScript。
- **偵測引擎**：TensorFlow.js + MoveNet Lightning。
- **背景**：AI 生成的史詩級對決背景圖 (`assets/background.jpg`)。
- **部署**：伺服器端需設定 Cache-Control: no-store 以防止手機快取問題。
- **相容性**：支援手機橫/直向滿版 (Object-fit: cover)，支援多點觸控。
