---
name: setup-o3-mcp
description: OpenAI o3検索MCPサーバーをClaude Codeに統合設定
---

# OpenAI o3検索MCP設定

OpenAI o3モデルを使用したWeb検索機能をClaude Codeに統合します。yoshiko-pg/o3-search-mcpを利用してAIパワードな検索機能を提供します。

## 実行内容

### 1. 前提条件の確認
```bash
# Node.js環境の確認
node --version
npm --version

# Claude Codeのバージョン確認
claude --version
```

### 2. OpenAI APIキーの設定
```bash
# 環境変数の設定（.envファイルまたはシステム環境変数）
export OPENAI_API_KEY="your-openai-api-key-here"

# .env.localファイルの作成（推奨）
echo "OPENAI_API_KEY=your-openai-api-key-here" > .env.local
```

### 3. MCPサーバーの設定（推奨方法）
```bash
# NPXを使用した自動セットアップ
claude mcp add o3 -s user \
    -e OPENAI_API_KEY="${OPENAI_API_KEY}" \
    -e SEARCH_CONTEXT_SIZE=medium \
    -e REASONING_EFFORT=medium \
    -- npx o3-search-mcp
```

### 4. 代替セットアップ（ローカル開発用）
```bash
# リポジトリのクローンとビルド
git clone https://github.com/yoshiko-pg/o3-search-mcp.git
cd o3-search-mcp
npm install  # または pnpm install
npm run build  # または pnpm build
```

### 5. Claude Code設定ファイルの更新
手動で設定ファイルに追加する場合：
```json
{
  "mcpServers": {
    "o3-search": {
      "command": "npx",
      "args": ["o3-search-mcp"],
      "env": {
        "OPENAI_API_KEY": "${OPENAI_API_KEY}",
        "SEARCH_CONTEXT_SIZE": "medium",
        "REASONING_EFFORT": "medium"
      }
    }
  }
}
```

## 設定パラメータ

### 必須設定
- **OPENAI_API_KEY**: OpenAI APIキー（必須）

### オプション設定
- **SEARCH_CONTEXT_SIZE**: 検索コンテキストサイズ
  - `low` - 軽量検索
  - `medium` - 標準検索（デフォルト）
  - `high` - 詳細検索

- **REASONING_EFFORT**: 推論レベル
  - `low` - 高速処理
  - `medium` - バランス型（デフォルト）
  - `high` - 高精度処理

## 使用方法

### Claude Code内での利用
MCPサーバー設定後、Claude Codeで以下の機能が利用可能：

1. **Web検索クエリ**
   - 最新情報の検索
   - 技術的な情報の調査
   - 複雑な検索クエリの実行

2. **AI支援検索**
   - OpenAI o3による検索結果の解析
   - 文脈理解に基づく情報抽出
   - 関連情報の推論と提案

### 実用例
```
# Claude Codeでの使用例
「最新のReact 19の新機能について検索して」
「TypeScript 5.6の変更点を調べて」
「Dockerのベストプラクティス2024を検索」
```

## セキュリティ考慮事項

### APIキー管理
- OpenAI APIキーを環境変数で管理
- .env.localファイルは.gitignoreに必ず追加
- 本番環境では適切なシークレット管理システムを使用

### アクセス制限
```bash
# .env.localファイルの権限設定
chmod 600 .env.local
```

## トラブルシューティング

### よくある問題
1. **APIキーエラー**
   - OpenAI APIキーの有効性確認
   - 環境変数の設定確認

2. **MCPサーバー接続エラー**
   - Node.js環境の確認
   - ネットワーク接続の確認

3. **検索結果が表示されない**
   - SEARCH_CONTEXT_SIZEの調整
   - REASONING_EFFORTの調整

## 動作確認

設定完了後、Claude Codeで以下を実行して動作確認：
```
「MCP o3検索機能をテストして、現在のJavaScript最新情報を検索してください」
```

正常に動作する場合、OpenAI o3による検索結果と解析が表示されます。