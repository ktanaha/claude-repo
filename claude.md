#### リファクタリング時
```
「このコードをリファクタリングしてください。
- 既存のテストを保持（動作変更なし）
- 小さなステップで段階的に改善
- 各ステップでテスト実行
- SOLID原則とDRY原則を適用
- 可読性とメンテナンス性を向上」
```

#### 継続的改善
```
「機能実装後にリファクタリングを行ってください。
- コードスメルの除去
- 重複コードの統合
- 関数・クラスの責任分離
- 命名の改善
- 各改善でテスト実行確認」
```# Claude Code開発ガイドライン

## 基本方針

Claude Codeを使用する際は、以下の原則を必ず適用してください。

### 1. フロントエンド・バックエンド分離アーキテクチャ

**技術スタック**
- **フロントエンド**: React (TypeScript推奨)
- **バックエンド**: Go
- **開発環境**: Docker + Docker Compose
- **API通信**: RESTful API または GraphQL

**プロジェクト構成**
```
project/
├── frontend/           # React アプリケーション
├── backend/           # Go API サーバー
├── docker-compose.yml # 開発環境定義
└── docs/             # API仕様書等
```

### 2. テスト駆動開発（TDD）の徹底

**Red-Green-Refactorサイクルの実践**
- 最初に失敗するテストを書く（Red）
- テストを通す最小限のコードを書く（Green）
- コードを改善する（Refactor）

**逐次リファクタリングの原則**
- 機能追加とリファクタリングは分離する
- 小さなステップで段階的に改善
- 各ステップでテストが通ることを確認
- リファクタリング前後で動作を変更しない

**フロントエンド・バックエンド別テスト戦略**
- **フロントエンド**: Jest + React Testing Library
- **バックエンド**: Go標準testingパッケージ + testify
- **E2E**: Cypress または Playwright

### 3. アーキテクチャパターンの適用

**バックエンドアーキテクチャ（Go）**
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

**フロントエンドアーキテクチャ（React）**
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

### 4. Docker開発環境

**必須構成**
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

### 5. 具体的な指示テンプレート

#### プロジェクト初期化
```
「React + Go + Dockerの開発環境をセットアップしてください。
- フロントエンドはReact with TypeScript
- バックエンドはGoでクリーンアーキテクチャ
- Docker Composeで開発環境構築
- 各層のテスト環境も含める」
```

#### API開発時（バックエンド）
```
「[API名]を実装してください。
- TDDで進める
- Goでクリーンアーキテクチャ適用
- OpenAPI 3.0.3仕様書も生成
- ドメインロジックを中心に設計」
```

#### UI開発時（フロントエンド）
```
「[コンポーネント名]を実装してください。
- React + TypeScript
- Atomic Designパターン
- React Testing Libraryでテスト
- APIとの通信部分は分離」
```

## リファクタリング戦略

### Martin Fowler式リファクタリング手法

**基本原則**
- 動作を変えずに内部構造を改善
- 小さなステップで安全に進める
- 各ステップでテストを実行
- リファクタリングと機能追加は分離

**主要なリファクタリングパターン**
- **Extract Method**: 長いメソッドを分割
- **Rename Variable/Function**: 意図を明確にする命名
- **Move Method**: 適切なクラス・モジュールに移動
- **Extract Class**: 責任が多すぎるクラスを分割
- **Inline Temp**: 不要な一時変数を除去

### t-wada式テストとリファクタリング

**テストファーストリファクタリング**
1. 既存のテストを実行して緑であることを確認
2. リファクタリング対象を特定
3. 小さな変更を1つずつ実施
4. 各変更後にテストを実行
5. 全テストが緑のまま進める

**コードスメルの除去優先順位**
- 重複コード（DRY原則違反）
- 長すぎる関数・メソッド
- 大きすぎるクラス
- 長すぎるパラメータリスト
- 不適切な命名

## 技術スタック詳細

### フロントエンド（React）
- **言語**: TypeScript
- **状態管理**: Context API / Redux Toolkit
- **スタイリング**: CSS Modules / Styled Components
- **テスト**: Jest + React Testing Library
- **ビルドツール**: Vite

### バックエンド（Go）
- **フレームワーク**: Gin / Echo / Chi
- **ORM**: GORM / SQLBoiler
- **テスト**: testify + gomock
- **API仕様**: OpenAPI 3.0.3 / Swagger
- **DB**: PostgreSQL

### 開発ツール
- **コンテナ**: Docker + Docker Compose
- **API通信**: axios / fetch
- **E2Eテスト**: Cypress / Playwright
- **CI/CD**: GitHub Actions

## 開発フロー

1. **環境構築**: Docker Composeで開発環境立ち上げ
2. **API設計**: OpenAPI 3.0.3仕様書作成
3. **バックエンド開発**: TDDでAPI実装
4. **継続的リファクタリング**: 機能実装後に小さなステップで改善
5. **フロントエンド開発**: モックAPIでUI作成
6. **フロントエンドリファクタリング**: コンポーネント設計改善
7. **統合**: 実際のAPIと接続
8. **E2Eテスト**: 全体動作確認

## 質問時のポイント

Claude Codeに指示する際は：
- 「フロントエンド（React）」「バックエンド（Go）」を明記
- 「TDDで」「クリーンアーキテクチャで」を指定
- Docker環境での開発を前提とする
- API仕様の定義を含める（OpenAPI 3.0.3）
- 逐次リファクタリングを前提とする
- 各層でのテスト戦略を明確化
- コードスメルの除去を含める

## 例外ケース

以下の場合のみ、シンプルな構造を許可：
- プロトタイプや学習目的
- 極小規模（単一ファイル）
- 一時的なスクリプト

**その場合も最低限のテストは必須**