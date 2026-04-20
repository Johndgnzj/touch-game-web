#!/bin/bash
# Kids Hero Play - 雲端部署腳本 (v3.0)
# 這個腳本會自動處理結構搬運與 Firebase 部署權限

PROJECT_ROOT="./"
DEPLOY_HUB="./ai-hero-platform"
PROJECT_ID="ai-agent-492807"
KEY_PATH="./key.json"

echo "🚀 開始執行 Kids Hero Play 雲端部署流程..."

# 1. 搬運重構後的檔案
echo "📦 準備實體檔案結構..."
rm -rf ${DEPLOY_HUB}/public/*
mkdir -p ${DEPLOY_HUB}/public/news
mkdir -p ${DEPLOY_HUB}/public/design/assets
mkdir -p ${DEPLOY_HUB}/public/design/js

# 入口與早報
cp ${PROJECT_ROOT}/src/index.html ${DEPLOY_HUB}/public/
cp ${PROJECT_ROOT}/src/news/*.html ${DEPLOY_HUB}/public/news/

# 遊戲模組與 Assets
cp ${PROJECT_ROOT}/src/games/hero-challenge/*.html ${DEPLOY_HUB}/public/design/
cp -R ${PROJECT_ROOT}/src/games/hero-challenge/assets/* ${DEPLOY_HUB}/public/design/assets/

# 公用 JS
cp ${PROJECT_ROOT}/src/common/js/history.js ${DEPLOY_HUB}/public/design/js/

# 2. 執行部署 (使用與 auto_deploy_all.sh 相同的權限機制)
echo "🔥 正在上傳至 Firebase ($PROJECT_ID)..."
export GOOGLE_APPLICATION_CREDENTIALS="${KEY_PATH}"
cd ${DEPLOY_HUB}

# 獲取臨時 Token
TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null)

if [ -n "$TOKEN" ]; then
    firebase deploy --only hosting --project ${PROJECT_ID} --non-interactive --token "$TOKEN"
else
    firebase deploy --only hosting --project ${PROJECT_ID} --non-interactive
fi

echo "✨ 部署完成！"
