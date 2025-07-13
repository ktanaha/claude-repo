#!/bin/bash

# Claude Code開発プロジェクト初期化スクリプト
# このスクリプトは開発開始前の必須初期化処理を自動実行します

set -e  # エラー時に即座に終了

echo "🚀 Claude Code開発プロジェクト初期化を開始します..."
echo ""

# 現在のディレクトリを取得
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

echo "📁 プロジェクトディレクトリ: $PROJECT_DIR"
echo "📝 プロジェクト名: $PROJECT_NAME"
echo ""

# 1. Gitリポジトリの確認・初期化
if [ ! -d .git ]; then
    echo "🔧 Gitリポジトリを初期化しています..."
    git init
    echo "✅ Gitリポジトリを初期化しました"
else
    echo "✅ Gitリポジトリが既に存在します"
fi

# 2. .gitignoreファイルの作成・確認
echo "📋 .gitignoreファイルをチェックしています..."
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
# Claude Code設定ファイル（重要）
claude.md
CLAUDE.md

# OS固有ファイル
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE設定
.vscode/
.idea/
*.swp
*.swo
*~

# ログファイル
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# 依存関係
node_modules/
vendor/

# 環境変数
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# ビルド出力
dist/
build/
*.o
*.a
*.so

# 一時ファイル
tmp/
temp/

# Docker関連
.dockerignore

# テストカバレッジ
coverage/
*.coverage
.nyc_output

# パッケージマネージャー関連
package-lock.json
yarn.lock
go.sum

# エディタ関連
.vscode/settings.json
.idea/
*.sublime-project
*.sublime-workspace

# プラットフォーム固有
*.exe
*.dll
*.dylib

# 開発用データベース
*.db
*.sqlite
*.sqlite3

# ローカル設定
.local
local.*
EOF
    echo "✅ .gitignoreファイルを作成しました"
else
    echo "✅ .gitignoreファイルが既に存在します"
fi

# 3. vibe-coding-loggerの統合
echo "🔗 vibe-coding-loggerを統合しています..."
if [ ! -d vibe-coding-logger ]; then
    if git submodule add https://github.com/ktanaha/vibe-coding-logger.git 2>/dev/null; then
        echo "✅ vibe-coding-loggerをサブモジュールとして統合しました"
    else
        # サブモジュールが失敗した場合は通常のクローンを試行
        git clone https://github.com/ktanaha/vibe-coding-logger.git
        echo "✅ vibe-coding-loggerをクローンして統合しました"
    fi
else
    echo "✅ vibe-coding-loggerが既に統合済みです"
fi

# 4. 必要なディレクトリ構造の作成
echo "📂 プロジェクト構造を作成しています..."
mkdir -p frontend/src/{components,hooks,services,stores,types}
mkdir -p frontend/public
mkdir -p backend/{cmd,internal/{domain,usecase,interface,infrastructure},pkg}
mkdir -p docs
echo "✅ プロジェクト構造を作成しました"

# 5. 基本的な設定ファイルの作成
echo "⚙️  基本設定ファイルを作成しています..."

# package.jsonのテンプレート（フロントエンド）
if [ ! -f frontend/package.json ]; then
    cat > frontend/package.json << EOF
{
  "name": "${PROJECT_NAME}-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "jest",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.0.0",
    "typescript": "^5.0.0",
    "vite": "^4.4.0",
    "jest": "^29.0.0",
    "@testing-library/react": "^13.0.0",
    "@testing-library/jest-dom": "^5.0.0"
  }
}
EOF
    echo "✅ frontend/package.jsonを作成しました"
fi

# go.modのテンプレート（バックエンド）
if [ ! -f backend/go.mod ]; then
    cd backend
    go mod init "${PROJECT_NAME}-backend"
    cd ..
    echo "✅ backend/go.modを作成しました"
fi

# docker-compose.ymlのテンプレート
if [ ! -f docker-compose.yml ]; then
    cat > docker-compose.yml << EOF
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true
    
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    volumes:
      - ./backend:/app
    environment:
      - GO_ENV=development
    depends_on:
      - db
    
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${PROJECT_NAME}_db
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
    echo "✅ docker-compose.ymlを作成しました"
fi

# 6. 初期コミット
echo "📝 初期コミットを実行しています..."
git add .gitignore README.md setup.sh
if [ -f docker-compose.yml ]; then
    git add docker-compose.yml
fi
if [ -f frontend/package.json ]; then
    git add frontend/package.json
fi
if [ -f backend/go.mod ]; then
    git add backend/go.mod
fi

if git commit -m "chore: プロジェクト初期化

- .gitignoreファイルを作成
- README.mdを追加
- setup.shスクリプトを追加
- vibe-coding-loggerを統合
- プロジェクト構造を作成
- 基本設定ファイルを追加

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>" 2>/dev/null; then
    echo "✅ 初期コミットを完了しました"
else
    echo "ℹ️  初期コミットはスキップされました（変更がないか、既にコミット済み）"
fi

# 7. 開発環境の準備確認
echo "🐳 開発環境を確認しています..."
if command -v docker-compose >/dev/null 2>&1; then
    if [ -f docker-compose.yml ]; then
        echo "✅ Docker Composeが利用可能です"
        echo "   開発環境を開始するには: docker-compose up"
    else
        echo "ℹ️  docker-compose.ymlが見つかりません"
    fi
else
    echo "ℹ️  Docker Composeがインストールされていません"
fi

echo ""
echo "🎉 初期化が完了しました！"
echo ""
echo "📋 次のステップ:"
echo "1. 機能開発前にテストを書く（Red）"
echo "2. テストを通す最小限の実装（Green）"
echo "3. コードを改善する（Refactor）"
echo ""
echo "🚀 開発を開始してください！"
echo "   - フロントエンド: cd frontend && npm install && npm run dev"
echo "   - バックエンド: cd backend && go run cmd/main.go"
echo "   - フルスタック: docker-compose up"