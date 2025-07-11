---
name: python-lint
description: Pythonプロジェクトの静的解析とフォーマットを実行
---

# Python Lint and Format

Pythonプロジェクトの静的解析とフォーマットを実行します。

## 実行内容

1. **コードフォーマット**
   ```bash
   black . || ruff format .
   ```

2. **インポート整理**
   ```bash
   isort .
   ```

3. **静的解析**
   ```bash
   ruff check . || flake8 .
   # 設定がある場合
   pylint .
   ```

4. **型チェック**
   ```bash
   # 設定がある場合
   mypy .
   pyright
   ```

5. **セキュリティチェック**
   ```bash
   bandit -r .
   safety check
   pip check
   ```

必要なツールがない場合は適切なインストール方法を提案し、エラーがある場合は詳細な情報を記録します。