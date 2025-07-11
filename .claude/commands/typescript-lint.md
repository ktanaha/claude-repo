---
name: typescript-lint
description: TypeScriptプロジェクトの静的解析とフォーマットを実行
---

# TypeScript Lint and Format

TypeScriptプロジェクトの静的解析とフォーマットを実行します。

## 実行内容

1. **コードフォーマット**
   ```bash
   npx prettier --write . || npm run format
   ```

2. **ESLint実行**
   ```bash
   npx eslint . --fix || npm run lint
   npx eslint .
   ```

3. **TypeScript型チェック**
   ```bash
   npx tsc --noEmit
   # 大規模プロジェクトの場合
   npx tsc --noEmit --incremental
   ```

4. **セキュリティチェック**
   ```bash
   npm audit
   # インストールされている場合
   npx depcheck
   ```

プロジェクトのpackage.jsonのscriptsを優先使用し、エラーがある場合は詳細な情報を記録します。