---
name: configure-mcp
description: Claude CodeのMCPサーバー設定と環境変数管理の統合セットアップ
---

# MCP統合設定

Claude CodeでMCPサーバーを安全に設定し、環境変数を適切に管理するための統合セットアップです。

## 実行内容

### 1. Claude Code設定ディレクトリの確認
```bash
# Claude Code設定ディレクトリの場所確認
ls -la ~/.claude/
ls -la ~/.config/claude/

# 設定ファイルの確認
cat ~/.claude/settings.json 2>/dev/null || echo "設定ファイルが見つかりません"
```

### 2. 環境変数設定ファイルの作成
```bash
# プロジェクトルートに.env.mcpファイル作成
cat > .env.mcp << 'EOF'
# OpenAI API設定
OPENAI_API_KEY=your-openai-api-key-here

# o3-search-mcp設定
SEARCH_CONTEXT_SIZE=medium
REASONING_EFFORT=medium

# その他のMCP設定
# 必要に応じて追加のAPIキーを設定
EOF

# ファイル権限を安全に設定
chmod 600 .env.mcp
```

### 3. .gitignoreへの追加
既存の.gitignoreに安全な設定を追加：
```gitignore
# MCP環境変数ファイル
.env.mcp
.env.local
.env.*.local

# Claude Code設定（プライベート）
.claude/settings.json
.claude/mcp_settings.json
```

### 4. MCPサーバー設定のテンプレート生成
```json
{
  "mcpServers": {
    "o3-search": {
      "command": "npx",
      "args": ["o3-search-mcp"],
      "env": {
        "OPENAI_API_KEY": "${OPENAI_API_KEY}",
        "SEARCH_CONTEXT_SIZE": "${SEARCH_CONTEXT_SIZE:-medium}",
        "REASONING_EFFORT": "${REASONING_EFFORT:-medium}"
      }
    }
  }
}
```

### 5. 環境変数の読み込み設定
```bash
# 環境変数を現在のシェルに読み込み
if [ -f .env.mcp ]; then
    export $(cat .env.mcp | grep -v '^#' | xargs)
    echo "MCP環境変数を読み込みました"
else
    echo "⚠️  .env.mcpファイルが見つかりません"
fi
```

## 自動セットアップスクリプト

### NPXによる自動設定
```bash
# 環境変数が設定されている場合の自動セットアップ
if [ -n "$OPENAI_API_KEY" ]; then
    echo "OpenAI APIキーが設定されています。MCPサーバーをセットアップします..."
    
    claude mcp add o3 -s user \
        -e OPENAI_API_KEY="${OPENAI_API_KEY}" \
        -e SEARCH_CONTEXT_SIZE="${SEARCH_CONTEXT_SIZE:-medium}" \
        -e REASONING_EFFORT="${REASONING_EFFORT:-medium}" \
        -- npx o3-search-mcp
        
    echo "✅ o3-search-mcp MCPサーバーのセットアップが完了しました"
else
    echo "❌ OPENAI_API_KEYが設定されていません"
    echo "手順："
    echo "1. .env.mcpファイルにAPIキーを設定"
    echo "2. source .env.mcpで環境変数を読み込み"
    echo "3. 再度このコマンドを実行"
fi
```

## 設定検証

### MCPサーバー接続テスト
```bash
# Claude CodeでMCPサーバーの状態確認
claude mcp list

# 特定のMCPサーバーの詳細確認
claude mcp status o3

# 接続テスト
claude mcp test o3
```

### 環境変数の確認
```bash
# 設定されている環境変数の確認（値は表示しない）
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:+設定済み}"
echo "SEARCH_CONTEXT_SIZE: ${SEARCH_CONTEXT_SIZE:-未設定}"
echo "REASONING_EFFORT: ${REASONING_EFFORT:-未設定}"
```

## セキュリティベストプラクティス

### 1. APIキー管理
- 環境変数ファイルの権限を600に設定
- .gitignoreで確実に除外
- 本番環境では専用のシークレット管理システムを使用

### 2. 設定ファイルの暗号化（オプション）
```bash
# GPGを使用した設定ファイルの暗号化
gpg --symmetric --cipher-algo AES256 .env.mcp
rm .env.mcp
# 使用時: gpg --decrypt .env.mcp.gpg > .env.mcp
```

### 3. ローテーション管理
```bash
# APIキーローテーション用のスクリプト例
update_api_key() {
    local new_key="$1"
    sed -i.bak "s/OPENAI_API_KEY=.*/OPENAI_API_KEY=${new_key}/" .env.mcp
    echo "APIキーを更新しました"
}
```

## トラブルシューティング

### よくある問題と解決方法

1. **MCPサーバーが認識されない**
   ```bash
   # Claude Code再起動
   claude restart
   
   # 設定ファイルの再読み込み
   claude mcp reload
   ```

2. **環境変数が読み込まれない**
   ```bash
   # 環境変数ファイルの確認
   cat .env.mcp | grep -v '^#'
   
   # 手動での環境変数設定
   export OPENAI_API_KEY="your-key-here"
   ```

3. **権限エラー**
   ```bash
   # ファイル権限の修正
   chmod 600 .env.mcp
   chown $USER:$USER .env.mcp
   ```

## 動作確認手順

1. 環境変数ファイルの作成と設定
2. .gitignoreへの追加確認
3. MCPサーバーのセットアップ実行
4. Claude CodeでMCP機能のテスト
5. 検索機能の動作確認

セットアップ完了後、Claude CodeでOpenAI o3による高精度なWeb検索機能が利用可能になります。