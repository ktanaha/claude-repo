---
name: git-init-setup
description: GitHubプロジェクト初期化（.gitignore、README.md作成、初回commit）
---

# Git初期化セットアップ

GitHubで管理するための初期化処理を実行します。安全な.gitignore設定、基本的なREADME.md作成、初回コミットまでを自動化します。

## 実行内容

1. **Git初期化**
   ```bash
   git init
   ```

2. **包括的な.gitignore作成**
   プライベートファイルとアクセスキーを除外する設定を追加：
   
   - Claude Code設定ファイル（claude.md、CLAUDE.md）
   - 認証情報・APIキー・環境変数
   - OS固有ファイル（.DS_Store等）
   - IDE設定ファイル
   - ログファイル・一時ファイル
   - 言語別ビルド成果物・依存関係
   - データベースファイル・キャッシュ

3. **README.md生成**
   プロジェクト構造を解析して基本的なREADME.mdを作成：
   
   - プロジェクト名と概要
   - 検出された技術スタック
   - インストール・実行手順
   - プロジェクト構造
   - 開発環境セットアップ手順

4. **初回コミット**
   ```bash
   git add .gitignore README.md
   git commit -m "Initial commit: プロジェクト初期化"
   ```

## セキュリティ対策

### 除外対象ファイル
- **認証情報**: `.env*`, `config/secrets.*`, `*.key`, `*.pem`
- **APIキー**: `*api*key*`, `*secret*`, `*token*`
- **設定ファイル**: `claude.md`, `CLAUDE.md`, `.vscode/`, `.idea/`
- **データベース**: `*.db`, `*.sqlite*`, `*.sql`
- **ログ**: `*.log`, `logs/`, `tmp/`

### 言語別除外設定
- **Node.js**: `node_modules/`, `npm-debug.log*`, `dist/`
- **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `*.egg-info/`
- **Go**: `*.exe`, `*.test`, `vendor/`
- **Rust**: `target/`, `Cargo.lock`
- **Java**: `*.class`, `target/`, `*.jar`

## 動作

1. プロジェクトディレクトリ内のファイルを解析
2. 技術スタックを自動検出
3. 適切な.gitignore設定を生成
4. プロジェクトに応じたREADME.mdを生成
5. 安全にコミット可能な状態にセットアップ

既存のGitリポジトリでも、.gitignoreとREADME.mdの更新に利用できます。