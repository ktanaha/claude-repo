---
name: create-gitignore
description: セキュアな.gitignoreファイルを生成（認証情報・APIキー・プライベートファイル除外）
---

# セキュア.gitignore生成

プライベート情報や認証情報を確実に除外する包括的な.gitignoreファイルを生成します。

## 生成される.gitignore内容

### Claude Code設定（必須除外）
```gitignore
# Claude Code設定ファイル（重要）
claude.md
CLAUDE.md
.claude/
```

### セキュリティ関連（重要）
```gitignore
# 環境変数・認証情報
.env
.env.*
.envrc
config/secrets.*
secrets.*
credentials.*
auth.*

# APIキー・トークン・証明書
*api*key*
*secret*
*token*
*.key
*.pem
*.p12
*.pfx
*.crt
*.cer

# 設定ファイル
config.json
settings.json
local_settings.py
```

### OS・IDE固有
```gitignore
# macOS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
$RECYCLE.BIN/

# Linux
*~
.fuse_hidden*
.directory
.Trash-*

# IDE・エディタ
.vscode/
.idea/
*.swp
*.swo
*~
.project
.settings/
.classpath
```

### 言語別設定

#### JavaScript/Node.js
```gitignore
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm
.eslintcache
.nyc_output
coverage/
dist/
build/
```

#### Python
```gitignore
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.venv/
venv/
ENV/
env/
```

#### Go
```gitignore
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work
go.work.sum
vendor/
```

#### Rust
```gitignore
target/
Cargo.lock
**/*.rs.bk
```

#### Java
```gitignore
*.class
*.log
*.ctxt
.mtj.tmp/
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
target/
.gradle/
build/
```

### データベース・ログ
```gitignore
# データベース
*.db
*.sqlite
*.sqlite3
*.sql
dump.rdb

# ログファイル
*.log
logs/
log/
tmp/
temp/
.tmp/

# キャッシュ
.cache/
.parcel-cache/
.sass-cache/
```

## 動作

1. プロジェクト内のファイル・ディレクトリを解析
2. 技術スタック（言語・フレームワーク）を自動検出
3. 検出された技術に応じた除外設定を追加
4. 既存の.gitignoreがある場合は安全にマージ
5. 重複設定を除去して最適化

プロジェクトの安全性を最優先に、機密情報の漏洩を防ぐ設定を生成します。