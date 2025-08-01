# TDDとテスト戦略

## 開発手順の強制ルール

### t-wada式TDD必須プロセス
**すべての開発作業は以下の手順で進める**（例外なし）：

#### 1. Red（失敗するテストを先に書く）
- 実装前に期待する動作をテストで定義
- テストが失敗することを確認
- テストの失敗理由を明確に把握

#### 2. Green（テストを通す最小限の実装）
- 美しさより動作を優先
- テストが通ることのみを目的とする
- 実装の詳細は後で改善

#### 3. Refactor（動作を変えずに改善）
- 動作を変更しない
- 各改善ステップでテスト実行
- コードの品質を向上させる

## 作業開始時の必須チェックリスト
**どんな機能開発でも、最初に以下を確認**：
- [ ] .gitignoreファイルが作成されているか？
- [ ] claude.mdとCLAUDE.mdが.gitignoreに記載されているか？
- [ ] vibe-coding-logger（https://github.com/ktanaha/vibe-coding-logger）がプロジェクトに統合されているか？
- [ ] ロギングシステムが適切に設定されているか？
- [ ] テストが書かれているか？
- [ ] テストが失敗するか？
- [ ] 実装はテストを通すだけか？
- [ ] リファクタリングでテストは通ったままか？

## 禁止事項（例外なし）
- 「とりあえず動くものを」→ 禁止
- 「テストは後で」→ 禁止
- 「簡単だからテスト不要」→ 禁止

**一行でもコードを書く前に、必ずテストから始める**

---

# テスト戦略

## テストツール
- **フロントエンド**: Jest + React Testing Library
- **バックエンド**: Go標準testingパッケージ + testify
- **E2E**: Cypress または Playwright

## リファクタリング戦略

### Martin Fowler式リファクタリング手法
**基本原則**：
- 動作を変えずに内部構造を改善
- 小さなステップで安全に進める
- 各ステップでテストを実行
- リファクタリングと機能追加は分離

**主要なリファクタリングパターン**：
- **Extract Method**: 長いメソッドを分割
- **Rename Variable/Function**: 意図を明確にする命名
- **Move Method**: 適切なクラス・モジュールに移動
- **Extract Class**: 責任が多すぎるクラスを分割
- **Inline Temp**: 不要な一時変数を除去

### コードスメルの除去優先順位
1. 重複コード（DRY原則違反）
2. 長すぎる関数・メソッド
3. 大きすぎるクラス
4. 長すぎるパラメータリスト
5. 不適切な命名

---

# 例外ケース

以下の場合のみ、シンプルな構造を許可：
- プロトタイプや学習目的
- 極小規模（単一ファイル）
- 一時的なスクリプト

**その場合も最低限のテストは必須**