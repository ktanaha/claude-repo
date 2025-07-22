# Claude Code開発ガイドライン

## 関連ドキュメント
- [TDDとテスト戦略](CLAUDE_TDD.md)
- [Git管理・バージョン管理](CLAUDE_GIT.md)
- [CI/CD設定](CLAUDE_CICD.md)
- [セキュリティ・安全性ルール](CLAUDE_SECURITY.md)
- [vibe-coding-logger統合ガイド](CLAUDE_LOGGER.md)
- [プロダクトバックログ管理](CLAUDE_BACKLOG.md)

## 言語設定・コミュニケーション方針
- **応答言語**: すべての応答を日本語で行う
- **コメント**: コード内のコメントも日本語で記述
- **説明**: 技術的な説明や手順も日本語で提供
- **プロジェクト全体**: すべてのやり取りを日本語で統一

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

# 例外ケース

以下の場合のみ、シンプルな構造を許可：
- プロトタイプや学習目的
- 極小規模（単一ファイル）
- 一時的なスクリプト

**その場合も最低限のテストは必須**

