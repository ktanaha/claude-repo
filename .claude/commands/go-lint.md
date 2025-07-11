---
name: go-lint
description: Goプロジェクトの静的解析とフォーマットを実行
---

# Go Lint and Format

Goプロジェクトの静的解析とフォーマットを実行します。

## 実行内容

1. **コードフォーマット**
   ```bash
   go fmt ./...
   ```

2. **インポート整理**
   ```bash
   # goimportsがある場合
   goimports -w .
   # ない場合はインストールを提案
   go install golang.org/x/tools/cmd/goimports@latest
   ```

3. **静的解析**
   ```bash
   go vet ./...
   # golangci-lintがある場合
   golangci-lint run
   ```

4. **ビルドチェック**
   ```bash
   go build ./...
   go mod tidy
   ```

5. **テスト実行**
   ```bash
   go test ./...
   go test -cover ./...
   ```

必要なツールがない場合は適切なインストール方法を提案し、エラーがある場合は詳細な情報を記録します。