---
name: lint-and-format
description: プロジェクトの言語を自動検出して適切なlintとformatを実行
---

# Lint and Format Code

プロジェクトの言語を自動検出し、適切な静的解析ツールとフォーマッターを実行します。

## 対応言語

### JavaScript/TypeScript
```bash
npx prettier --write .
npx eslint . --fix
npx tsc --noEmit  # TypeScriptのみ
```

### Python
```bash
black . || ruff format .
ruff check . || flake8 .
isort .
mypy .  # 設定がある場合
```

### Go
```bash
go fmt ./...
goimports -w .
go vet ./...
golangci-lint run
```

### Rust
```bash
cargo fmt
cargo clippy -- -D warnings
cargo check
```

### Java
```bash
mvn spotless:apply || ./gradlew spotlessApply
mvn checkstyle:check || ./gradlew checkstyleMain
```

### C/C++
```bash
clang-format -i **/*.{c,cpp,h,hpp}
clang-tidy **/*.{c,cpp}
```

## 動作

1. ファイル拡張子と設定ファイルから言語を検出
2. 適切なツールでlintとformatを実行
3. エラーがある場合は詳細を記録して修正を提案

複数言語の場合はすべてに対して順次実行します。