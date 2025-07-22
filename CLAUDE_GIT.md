# Git管理・バージョン管理

## .gitignoreファイルの必須作成ルール
**すべてのプロジェクトで.gitignoreファイルを必ず作成する**（例外なし）

### 必須実行項目
1. **プロジェクト初期化時**: 最初にgit initを実行したら、即座に.gitignoreを作成
2. **claude.md必須除外**: claude.mdとCLAUDE.mdを必ず.gitignoreに記載
3. **環境別設定**: 各技術スタックに応じた適切な除外設定を追加

### .gitignoreの必須項目
新しいプロジェクトでは、以下を必ず.gitignoreに含める：

```gitignore
# Claude Code設定ファイル（重要）
claude.md
CLAUDE.md
CLAUDE_*.md

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
```

## コミットメッセージ規約
**Conventional Commits**形式を使用：

```
<type>(<scope>): <description>

<body>

<footer>
```

### コミットタイプ
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの意味に影響しない変更（空白、フォーマット等）
- `refactor`: バグ修正でも機能追加でもないコード変更
- `test`: テストの追加・修正
- `chore`: ビルドプロセス、補助ツール等の変更

### 例
```
feat(auth): ユーザー認証機能を実装

- JWT トークンベースの認証
- ログイン・ログアウト機能
- パスワードバリデーション

Closes #123
```

## ブランチ戦略
**Git Flow**を採用：

```
main         # 本番環境用
develop      # 開発統合用
feature/     # 機能開発用
hotfix/      # 緊急修正用
release/     # リリース準備用
```

### ブランチ命名規則
- `feature/issue-123-user-auth`
- `hotfix/fix-login-bug`
- `release/v1.2.0`

## プルリクエスト・マージリクエスト
**必須項目**：
- [ ] テストが全て通る
- [ ] コードレビューが完了
- [ ] CLAUDE.mdの指針に従っている
- [ ] TDDプロセスを経ている

**テンプレート**：
```markdown
## 概要
何を変更したか、なぜ変更したかを簡潔に説明

## 変更内容
- [ ] 新機能の追加
- [ ] バグ修正
- [ ] リファクタリング
- [ ] ドキュメント更新

## テスト
- [ ] 単体テスト追加/更新
- [ ] 統合テスト確認
- [ ] 手動テスト実施

## 関連Issue
Closes #123
```

## リリース管理
**セマンティックバージョニング**を使用：
- `MAJOR.MINOR.PATCH` (例: v1.2.3)
- MAJOR: 互換性のない変更
- MINOR: 後方互換性のある機能追加
- PATCH: 後方互換性のあるバグ修正