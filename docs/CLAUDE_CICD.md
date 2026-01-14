# CI/CD設定

## 必須CI/CD設定ファイル作成
**すべてのプロジェクトで自動化されたCI/CDパイプラインを構築する**（例外なし）

### GitHub Actions設定
`.github/workflows/ci.yml`を作成：

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test_db
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_pass
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: frontend/package-lock.json
    
    - name: Install backend dependencies
      working-directory: backend
      run: go mod download
    
    - name: Install frontend dependencies
      working-directory: frontend
      run: npm ci
    
    - name: Run backend tests
      working-directory: backend
      run: go test -v ./...
      env:
        DATABASE_URL: postgres://test_user:test_pass@localhost:5432/test_db?sslmode=disable
    
    - name: Run frontend tests
      working-directory: frontend
      run: npm test -- --coverage --watchAll=false
    
    - name: Build frontend
      working-directory: frontend
      run: npm run build
    
    - name: Build backend
      working-directory: backend
      run: go build -v ./...

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Deploy to staging
      run: echo "デプロイプロセスをここに記述"
```

### GitLab CI設定
`.gitlab-ci.yml`を作成：

```yaml
stages:
  - test
  - build
  - deploy

variables:
  POSTGRES_DB: test_db
  POSTGRES_USER: test_user
  POSTGRES_PASSWORD: test_pass

test:
  stage: test
  image: golang:1.21
  services:
    - postgres:15
  script:
    - cd backend && go test -v ./...
    - cd frontend && npm ci && npm test -- --coverage --watchAll=false
  coverage: '/coverage: \d+\.\d+% of statements/'

build:
  stage: build
  script:
    - cd backend && go build -v ./...
    - cd frontend && npm run build
  artifacts:
    paths:
      - frontend/dist/
    expire_in: 1 hour

deploy:
  stage: deploy
  script:
    - echo "デプロイプロセスをここに記述"
  only:
    - main
```

## CI/CDパイプライン要件

### 必須項目
- [ ] 全テストの自動実行
- [ ] フロントエンド・バックエンドのビルド確認
- [ ] 静的解析（リンター、型チェック）
- [ ] セキュリティスキャン
- [ ] カバレッジレポート生成
- [ ] vibe-coding-loggerの統合テスト

### ブランチ戦略連携
- **main**: 本番デプロイ
- **develop**: ステージングデプロイ
- **feature/**: テストのみ実行
- **hotfix/**: 緊急パッチデプロイ

### 品質ゲート
- テストカバレッジ: 最低80%
- テスト成功率: 100%
- セキュリティ脆弱性: High/Critical 0件
- 型エラー: 0件