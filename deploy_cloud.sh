#!/bin/bash
# Kids Hero Play - 雲端部署腳本 (v2.1)
PROJECT_ROOT="/Users/ws011/Documents/vibe_projects/touch-game-web"
DEPLOY_HUB="/Users/ws011/Documents/vibe_projects/ai-hero-platform"
PROJECT_ID="ai-agent-492807"

echo "🚀 開始執行 Kids Hero Play 雲端部署..."

# 1. 清理與建立結構
echo "🧹 準備實體目錄..."
rm -rf ${DEPLOY_HUB}/public/*
mkdir -p ${DEPLOY_HUB}/public/news
mkdir -p ${DEPLOY_HUB}/public/design/assets

# 2. 搬運最新檔案
echo "📦 搬運重構後的檔案..."
cp ${PROJECT_ROOT}/src/index.html ${DEPLOY_HUB}/public/
cp ${PROJECT_ROOT}/src/news/*.html ${DEPLOY_HUB}/public/news/

# 處理遊戲模組
cp ${PROJECT_ROOT}/src/games/hero-challenge/*.html ${DEPLOY_HUB}/public/design/
cp -R ${PROJECT_ROOT}/src/games/hero-challenge/assets/* ${DEPLOY_HUB}/public/design/assets/

# 處理共用 JS
mkdir -p ${DEPLOY_HUB}/public/design/js
cp ${PROJECT_ROOT}/src/common/js/history.js ${DEPLOY_HUB}/public/design/js/

# 3. 部署至 Firebase
echo "🔥 上傳至 Firebase ($PROJECT_ID)..."
cd ${DEPLOY_HUB}
firebase deploy --only hosting --project ${PROJECT_ID}
