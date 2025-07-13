# Claude Code開発プロジェクト

Claude Code（https://claude.ai/code）を使用した開発プロジェクトのテンプレートリポジトリです。

## 概要

このプロジェクトは、Claude Codeとの効率的な開発を実現するための設定とガイドラインを提供します。
TDD（テスト駆動開発）とクリーンアーキテクチャを基盤とした、モダンなフルスタック開発環境を構築できます。

## 特徴

- **TDD強制**: t-wada式のRed-Green-Refactorサイクルを厳格に適用
- **クリーンアーキテクチャ**: 保守性と拡張性を重視した設計
- **フルスタック対応**: React + TypeScript + Go + Docker構成
- **ロギング統合**: vibe-coding-logger による開発プロセスの記録
- **Git管理**: 適切な.gitignoreとコミット規約の設定

## 技術スタック

### フロントエンド
- React with TypeScript
- Atomic Design パターン
- Jest + React Testing Library
- Vite（ビルドツール）

### バックエンド
- Go
- Gin フレームワーク
- クリーンアーキテクチャ
- 標準testing + testify

### 開発環境
- Docker + Docker Compose
- PostgreSQL
- Hot reload対応（Air for Go, Vite for React）

## プロジェクト構成

```
project/
├── frontend/           # React アプリケーション
│   ├── src/
│   │   ├── components/ # UI コンポーネント
│   │   ├── hooks/      # カスタムフック
│   │   ├── services/   # API通信
│   │   ├── stores/     # 状態管理
│   │   └── types/      # TypeScript型定義
│   └── public/
├── backend/            # Go API サーバー
│   ├── cmd/            # エントリーポイント
│   ├── internal/
│   │   ├── domain/     # エンティティ、ビジネスルール
│   │   ├── usecase/    # アプリケーションロジック
│   │   ├── interface/  # コントローラー、プレゼンター
│   │   └── infrastructure/ # DB、外部API実装
│   └── pkg/            # 共通ライブラリ
├── docker-compose.yml  # 開発環境定義
├── docs/               # API仕様書等
├── .gitignore          # Git除外設定
├── claude.md           # Claude Code設定
└── README.md           # このファイル
```

## 他のプロジェクトでの使用方法

### ⚠️ このリポジトリをサブモジュールとして統合

このリポジトリは、他のプロジェクトにサブモジュールとして統合することで、Claude Code開発ガイドラインを共有できます。

**ワンライナーで統合:**
```bash
curl -fsSL https://raw.githubusercontent.com/ktanaha/claude-repo/master/setup.sh | bash
```

**手動での統合:**
```bash
# 既存のプロジェクトディレクトリで実行
./setup.sh

# オプション付きでの実行
./setup.sh --help           # ヘルプを表示
./setup.sh --force          # 既存のサブモジュールを強制再作成
./setup.sh --no-link        # シンボリックリンクを作成しない
```

**統合により自動実行される処理:**
- サブモジュールとしてclaude-repoを追加
- .gitignoreファイルの更新（claude.md、CLAUDE.mdを除外）
- CLAUDE.mdへのシンボリックリンク作成
- 必要なGit設定の追加

**統合後のプロジェクト構造:**
```
your-project/
├── claude-guidelines/      # サブモジュール
│   ├── claude.md          # 開発ガイドライン
│   ├── setup.sh           # 統合スクリプト
│   └── README.md          # このファイル
├── CLAUDE.md              # シンボリックリンク → claude-guidelines/claude.md
├── .gitignore             # 自動更新済み
└── （あなたのプロジェクトファイル）
```

## サブモジュール管理

### サブモジュールの更新
```bash
# ガイドラインを最新版に更新
git submodule update --remote claude-guidelines

# サブモジュールを含めてクローン
git clone --recursive [your-repository-url]

# 既存リポジトリでサブモジュールを初期化
git submodule init
git submodule update
```

## 開発の始め方

### 1. 環境セットアップ（初期化後）

```bash
# 開発環境起動
docker-compose up
```

### 2. 個別プロジェクトのセットアップ

```bash
# フロントエンド開発環境
cd frontend
npm install
npm run dev

# バックエンド開発環境
cd backend
go mod tidy
go run cmd/main.go
```

### 3. 開発フロー

1. **Red**: 失敗するテストを先に書く
2. **Green**: テストを通す最小限の実装
3. **Refactor**: 動作を変えずに改善
4. **継続**: 全機能でこのサイクルを繰り返す

## 開発ルール

### 必須事項
- ✅ 全ての開発はTDDで行う
- ✅ テストが失敗することを確認してから実装
- ✅ 実装後は必ずリファクタリング
- ✅ コミット前にテストが全て通ることを確認

### 禁止事項
- ❌ 「とりあえず動くもの」の実装
- ❌ 「テストは後で」の姿勢
- ❌ テストなしでのコミット

## テスト戦略

### フロントエンド
- Jest + React Testing Library
- コンポーネント単体テスト
- ユーザーインタラクションテスト

### バックエンド
- Go標準testing + testify
- 単体テスト・統合テスト
- API エンドポイントテスト

### E2E
- Cypress または Playwright
- ユーザーシナリオテスト

## API設計

- RESTful API または GraphQL
- OpenAPI 3.0.3 仕様書
- リクエスト・レスポンスのロギング

## Git管理

### コミット規約
Conventional Commits形式を使用：

```
<type>(<scope>): <description>

<body>

<footer>
```

### ブランチ戦略
Git Flow を採用：

- `main`: 本番環境用
- `develop`: 開発統合用
- `feature/`: 機能開発用
- `hotfix/`: 緊急修正用
- `release/`: リリース準備用

## 設定ファイル

### 重要なファイル
- `claude.md`: Claude Code設定（.gitignoreで除外）
- `CLAUDE.md`: プロジェクト指針（.gitignoreで除外）
- `.gitignore`: Git除外設定
- `docker-compose.yml`: 開発環境設定

## リファクタリング

Martin Fowler式のリファクタリング手法を適用：

1. **Extract Method**: 長いメソッドを分割
2. **Rename Variable/Function**: 意図を明確にする命名
3. **Move Method**: 適切な場所に移動
4. **Extract Class**: 責任の分離
5. **Inline Temp**: 不要な一時変数を除去

## セキュリティ

- 危険なコマンドの実行制限
- 個人情報のログ除外
- 環境変数による設定管理
- 適切な権限設定

## 監視・ロギング

vibe-coding-logger による開発プロセスの記録：

- APIリクエスト/レスポンス
- ユーザーアクション
- エラーハンドリング
- パフォーマンス指標

## ライセンス

このプロジェクトは[ライセンス名]の下で公開されています。

## 貢献

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'feat: add amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## サポート

- 質問やバグ報告は [Issues](../../issues) へ
- 開発に関する相談は [Discussions](../../discussions) へ

---

**注意**: このプロジェクトは開発効率とコード品質の両立を目的としています。
全ての開発作業において、TDDの原則を厳守することが成功の鍵となります。