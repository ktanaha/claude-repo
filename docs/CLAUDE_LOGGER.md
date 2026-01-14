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

## ログレベル設定
```
TRACE: 最も詳細なデバッグ情報
DEBUG: 開発時のデバッグ情報
INFO: 一般的な情報
WARN: 警告レベルの情報
ERROR: エラー情報
FATAL: 致命的なエラー
```

## プライバシー・セキュリティ考慮事項
- パスワード、トークン、個人識別情報をログに記録しない
- ログローテーション機能を有効化
- ログファイルへの適切なアクセス権限設定
- 本番環境でのログ保存期間を制限