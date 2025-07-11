---
name: test-and-commit
description: テスト実行後、成功時はcommit、失敗時はエラーをドキュメント化して修正
---

# Test and Commit Workflow

ユニットテストを実行し、成功時はcommit、失敗時はエラーをドキュメント化してから修正を試みます。

## 実行内容

1. **テスト実行**
   ```bash
   # プロジェクトに応じて適切なコマンドを選択
   npm test || pytest || go test ./... || cargo test
   ```

2. **成功時**: 全テスト通過後にcommit
   ```bash
   git add .
   git commit -m "適切なメッセージ"
   ```

3. **失敗時**: エラー情報を`test-errors.md`に記録後、修正を試みる

## エラードキュメント形式

```markdown
# Test Error Report - [YYYY-MM-DD HH:MM:SS]

## Failed Tests
[失敗したテスト名とファイル]

## Error Details
[エラーメッセージの詳細]

## Affected Files
[影響を受けるファイル一覧]

## Suggested Fix Strategy
[修正方針の提案]
```

修正後は再度このワークフローを実行します。