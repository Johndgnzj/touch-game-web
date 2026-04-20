#!/bin/bash
# Kids Hero Play - 雲端部署腳本
PROJECT_ROOT="/Users/ws011/Documents/vibe_projects/touch-game-web"
DEPLOY_HUB="/Users/ws011/Documents/vibe_projects/ai-hero-platform"

echo "🚀 開始部署..."
rm -rf ${DEPLOY_HUB}/public/*
mkdir -p ${DEPLOY_HUB}/public/news
mkdir -p ${DEPLOY_HUB}/public/design/assets

# 複製檔案
cp ${PROJECT_ROOT}/src/index.html ${DEPLOY_HUB}/public/
cp ${PROJECT_ROOT}/src/news/*.html ${DEPLOY_HUB}/public/news/
cp ${PROJECT_ROOT}/src/games/hero-challenge/*.html ${DEPLOY_HUB}/public/design/
cp -R ${PROJECT_ROOT}/src/games/hero-challenge/assets/* ${DEPLOY_HUB}/public/design/assets/

# 部署
cd ${DEPLOY_HUB}
firebase deploy --only hosting --project ai-agent-492807
