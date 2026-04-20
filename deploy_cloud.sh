#!/bin/bash
# Kids Hero Play - 雲端部署腳本 (v3.0)
# 這個腳本會自動處理結構搬運與 Firebase 部署權限

PROJECT_ROOT="./"
DEPLOY_HUB="./ai-hero-platform"
PROJECT_ID="ai-agent-492807"
KEY_PATH="./key.json"

echo "🚀 開始執行 Kids Hero Play 雲端部署流程..."

# -1. 切到 .nvmrc 指定的 Node 版本（Firebase CLI 14 要求 Node >= 20）
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nvm/nvm.sh" >/dev/null 2>&1
    if [ -f .nvmrc ]; then
        nvm use >/dev/null 2>&1 || nvm install
    fi
fi
NODE_MAJOR="$(node -v 2>/dev/null | sed -E 's/v([0-9]+).*/\1/')"
if [ "${NODE_MAJOR:-0}" -lt 20 ]; then
    echo "❌ Firebase CLI 需要 Node >= 20（目前 $(node -v 2>/dev/null || echo '未安裝')）"
    echo "   請執行 'nvm install' 或手動切到 .nvmrc 指定版本後再跑"
    exit 1
fi

# -0.5. 隔離 Firebase CLI 的 configstore，避免快取的 user auth 蓋掉 service account
FIREBASE_CFG_DIR="$(mktemp -d -t fb-deploy-XXXXXX)"
trap 'rm -rf "$FIREBASE_CFG_DIR"' EXIT
export XDG_CONFIG_HOME="$FIREBASE_CFG_DIR"

# 0. 確保 Firebase 設定存在（ai-hero-platform/ 在 .gitignore，避免新環境缺 config）
mkdir -p ${DEPLOY_HUB}
if [ ! -f "${DEPLOY_HUB}/firebase.json" ]; then
    echo "⚙️  產生 firebase.json 預設設定..."
    cat > "${DEPLOY_HUB}/firebase.json" <<'JSON'
{
  "hosting": {
    "public": "public",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "cleanUrls": true
  }
}
JSON
fi
if [ ! -f "${DEPLOY_HUB}/.firebaserc" ]; then
    echo "⚙️  產生 .firebaserc 預設設定..."
    cat > "${DEPLOY_HUB}/.firebaserc" <<JSON
{
  "projects": {
    "default": "${PROJECT_ID}"
  }
}
JSON
fi

# 1. 鏡射 src/ → public/，結構 1:1 對應（保持開發與部署路徑一致）
echo "📦 準備實體檔案結構..."
rm -rf "${DEPLOY_HUB}/public"
mkdir -p "${DEPLOY_HUB}/public"
rsync -a --exclude='.DS_Store' "${PROJECT_ROOT}/src/" "${DEPLOY_HUB}/public/"

# 3. 部署至 Firebase
echo "🔥 正在上傳至 Firebase ($PROJECT_ID)..."

# 將認證金鑰展成絕對路徑，避免 cd 之後失效
if [ -f "${KEY_PATH}" ]; then
    export GOOGLE_APPLICATION_CREDENTIALS="$(cd "$(dirname "${KEY_PATH}")" && pwd)/$(basename "${KEY_PATH}")"
fi

# 進入部署目錄，firebase CLI 會自動讀取同目錄的 firebase.json / .firebaserc
cd "${DEPLOY_HUB}"

firebase deploy --only hosting --project ${PROJECT_ID} --non-interactive

echo "✨ 部署完成！"
