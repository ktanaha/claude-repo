# Claude Code開発ガイドライン

## 言語設定・コミュニケーション方針
- **応答言語**: すべての応答を日本語で行う
- **コメント**: コード内のコメントも日本語で記述
- **説明**: 技術的な説明や手順も日本語で提供
- **プロジェクト全体**: すべてのやり取りを日本語で統一

---

# 開発手順の強制ルール

## t-wada式TDD必須プロセス
**すべての開発作業は以下の手順で進める**（例外なし）：

### 1. Red（失敗するテストを先に書く）
- 実装前に期待する動作をテストで定義
- テストが失敗することを確認
- テストの失敗理由を明確に把握

### 2. Green（テストを通す最小限の実装）
- 美しさより動作を優先
- テストが通ることのみを目的とする
- 実装の詳細は後で改善

### 3. Refactor（動作を変えずに改善）
- 動作を変更しない
- 各改善ステップでテスト実行
- コードの品質を向上させる

## 作業開始時の必須チェックリスト
**どんな機能開発でも、最初に以下を確認**：
- [ ] .gitignoreファイルが作成されているか？
- [ ] claude.mdとCLAUDE.mdが.gitignoreに記載されているか？
- [ ] vibe-coding-logger（https://github.com/ktanaha/vibe-coding-logger）がプロジェクトに統合されているか？
- [ ] ロギングシステムが適切に設定されているか？
- [ ] テストが書かれているか？
- [ ] テストが失敗するか？
- [ ] 実装はテストを通すだけか？
- [ ] リファクタリングでテストは通ったままか？

## 禁止事項（例外なし）
- 「とりあえず動くものを」→ 禁止
- 「テストは後で」→ 禁止
- 「簡単だからテスト不要」→ 禁止

**一行でもコードを書く前に、必ずテストから始める**

---

# アーキテクチャ・技術スタック

## 基本方針
フロントエンド・バックエンド分離アーキテクチャを必須とする

## 技術スタック
- **フロントエンド**: React (TypeScript必須)
- **バックエンド**: Go
- **開発環境**: Docker + Docker Compose
- **API通信**: RESTful API または GraphQL

## プロジェクト構成
```
project/
├── frontend/           # React アプリケーション
├── backend/           # Go API サーバー
├── docker-compose.yml # 開発環境定義
└── docs/             # API仕様書等
```

## バックエンドアーキテクチャ（Go）
- **小規模**: レイヤードアーキテクチャ
- **中規模以上**: クリーンアーキテクチャ

```
backend/
├── cmd/              # エントリーポイント
├── internal/
│   ├── domain/       # エンティティ、ビジネスルール
│   ├── usecase/      # アプリケーションロジック
│   ├── interface/    # コントローラー、プレゼンター
│   └── infrastructure/ # DB、外部API実装
└── pkg/              # 共通ライブラリ
```

## フロントエンドアーキテクチャ（React）
- **コンポーネント設計**: Atomic Design
- **状態管理**: Context API または Redux Toolkit

```
frontend/
├── src/
│   ├── components/   # UI コンポーネント
│   ├── hooks/        # カスタムフック
│   ├── services/     # API通信
│   ├── stores/       # 状態管理
│   └── types/        # TypeScript型定義
└── public/
```

---

# テスト戦略

## テストツール
- **フロントエンド**: Jest + React Testing Library
- **バックエンド**: Go標準testingパッケージ + testify
- **E2E**: Cypress または Playwright

## リファクタリング戦略

### Martin Fowler式リファクタリング手法
**基本原則**：
- 動作を変えずに内部構造を改善
- 小さなステップで安全に進める
- 各ステップでテストを実行
- リファクタリングと機能追加は分離

**主要なリファクタリングパターン**：
- **Extract Method**: 長いメソッドを分割
- **Rename Variable/Function**: 意図を明確にする命名
- **Move Method**: 適切なクラス・モジュールに移動
- **Extract Class**: 責任が多すぎるクラスを分割
- **Inline Temp**: 不要な一時変数を除去

### コードスメルの除去優先順位
1. 重複コード（DRY原則違反）
2. 長すぎる関数・メソッド
3. 大きすぎるクラス
4. 長すぎるパラメータリスト
5. 不適切な命名

---

# Docker開発環境

## 必須構成
```yaml
# docker-compose.yml テンプレート
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
  
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    volumes:
      - ./backend:/app
    environment:
      - GO_ENV=development
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: app_db
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
```

---

# 開発指示テンプレート

## プロジェクト初期化
```
「React + Go + Dockerの開発環境をセットアップしてください。
- フロントエンドはReact with TypeScript
- バックエンドはGoでクリーンアーキテクチャ
- Docker Composeで開発環境構築
- 各環境のバージョンは整合性がとれるものを選択
- 各層のテスト環境も含める
- 【必須】vibe-coding-logger（https://github.com/ktanaha/vibe-coding-logger）を統合し、開発中のロギング機能を実装する
- 【重要】git initと同時に.gitignoreを作成し、claude.mdとCLAUDE.mdを必ず除外する」
```

## API開発時（バックエンド）
```
「[API名]を実装してください。
- TDDで進める（Red-Green-Refactor厳守）
- Goでクリーンアーキテクチャ適用
- vibe-coding-loggerを使用してリクエスト・レスポンスをログ出力
- OpenAPI 3.0.3仕様書も生成
- ドメインロジックを中心に設計」
```

## UI開発時（フロントエンド）
```
「[コンポーネント名]を実装してください。
- TDDで進める（Red-Green-Refactor厳守）
- React + TypeScript
- Atomic Designパターン
- React Testing Libraryでテスト
- vibe-coding-loggerを使用してユーザーアクションとAPIコールをログ出力
- APIとの通信部分は分離」
```

## リファクタリング時
```
「このコードをリファクタリングしてください。
- 既存のテストを保持（動作変更なし）
- 小さなステップで段階的に改善
- 各ステップでテスト実行
- SOLID原則とDRY原則を適用
- 可読性とメンテナンス性を向上」
```

---

# 開発フロー

1. **環境構築**: Docker Composeで開発環境立ち上げ
2. **ロギング統合**: vibe-coding-loggerをプロジェクトに統合
3. **API設計**: OpenAPI 3.0.3仕様書作成
4. **バックエンド開発**: TDDでAPI実装（ロギング機能含む）
5. **継続的リファクタリング**: 機能実装後に小さなステップで改善
6. **フロントエンド開発**: モックAPIでUI作成（ロギング機能含む）
7. **フロントエンドリファクタリング**: コンポーネント設計改善
8. **統合**: 実際のAPIと接続
9. **E2Eテスト**: 全体動作確認

---

# セキュリティ・安全性ルール

## 危険なコマンドの実行制限
以下のコマンドは**絶対に無断で実行しない**。必ずユーザーに確認を取る：

- `rm` / `rm -rf` - ファイル・ディレクトリの削除
- `sudo rm` - 管理者権限での削除
- `dd` - ディスクの直接書き込み
- `chmod 777` - 危険な権限変更
- `sudo` 全般 - 管理者権限が必要な操作
- `curl | sh` / `wget | sh` - 未検証スクリプトの実行

## 実行前確認が必要な操作
- ファイルの移動・削除
- システム設定の変更
- 外部からのスクリプトダウンロード・実行
- データベースの変更・削除操作

## 確認方法
危険な操作を提案する際は、以下の情報を含めて確認を求める：
- 実行するコマンドの詳細
- 影響範囲の説明
- 元に戻す方法（可能な場合）

---

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

---

# 例外ケース

以下の場合のみ、シンプルな構造を許可：
- プロトタイプや学習目的
- 極小規模（単一ファイル）
- 一時的なスクリプト

**その場合も最低限のテストは必須**

---

# vibe-coding-logger統合ガイド

## 必須統合手順
**すべての開発プロジェクトで以下を実行**（例外なし）：

### 1. プロジェクト開始時
```bash
# vibe-coding-loggerのクローンまたは統合
git submodule add https://github.com/ktanaha/vibe-coding-logger.git
# または
git clone https://github.com/ktanaha/vibe-coding-logger.git
```

### 2. バックエンド（Go）への統合
```go
// パッケージの追加
import "github.com/ktanaha/vibe-coding-logger/pkg/logger"

// 初期化
logger := logger.New()

// 使用例
logger.Info("API開始", map[string]interface{}{
    "endpoint": "/api/users",
    "method": "GET",
})
```

### 3. フロントエンド（React/TypeScript）への統合
```typescript
// vibe-coding-loggerのクライアントライブラリを使用
import { VibeCodingLogger } from 'vibe-coding-logger';

const logger = new VibeCodingLogger();

// 使用例
logger.logUserAction('button_click', {
    component: 'LoginButton',
    timestamp: new Date().toISOString()
});
```

### 4. Docker環境での設定
```yaml
# docker-compose.ymlに追加
services:
  backend:
    environment:
      - VIBE_LOGGER_ENABLED=true
      - VIBE_LOGGER_LEVEL=debug
  
  frontend:
    environment:
      - REACT_APP_VIBE_LOGGER_ENABLED=true
```

## ロギング対象
### バックエンド
- APIリクエスト/レスポンス
- データベース操作
- エラーハンドリング
- ビジネスロジック実行

### フロントエンド
- ユーザーアクション（クリック、入力等）
- API呼び出し
- ページ遷移
- エラー発生

## 設定要件
- 開発環境では詳細ログを有効化
- 本番環境では必要最小限のログのみ
- 個人情報は絶対にログに含めない
- パフォーマンスに影響しない設定