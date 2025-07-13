#!/bin/bash

# Claude Code開発ガイドライン統合スクリプト
# このスクリプトは他のプロジェクトにclaude-repoをサブモジュールとして統合します

set -e

# 色付きの出力関数
print_info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# ヘルプ表示
show_help() {
    cat << EOF
Claude Code開発ガイドライン統合スクリプト

使用方法:
  $0 [オプション]

オプション:
  -h, --help     このヘルプを表示
  -f, --force    既存のサブモジュールを強制的に再作成
  -n, --no-link  シンボリックリンクを作成しない

説明:
  このスクリプトは、現在のプロジェクトにclaude-repoをサブモジュールとして追加し、
  CLAUDE.mdへのシンボリックリンクを作成します。また、.gitignoreファイルに
  必要な設定を追加します。

例:
  $0                 # 標準的な統合
  $0 --force         # 既存のサブモジュールを強制再作成
  $0 --no-link       # シンボリックリンクを作成せずに統合のみ

EOF
}

# コマンドライン引数の処理
FORCE=false
NO_LINK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -n|--no-link)
            NO_LINK=true
            shift
            ;;
        *)
            print_error "不明なオプション: $1"
            echo "ヘルプを表示するには $0 --help を実行してください"
            exit 1
            ;;
    esac
done

# Gitリポジトリかチェック（なければ初期化）
if [ ! -d ".git" ]; then
    print_info "Gitリポジトリを初期化しています..."
    git init
    print_success "Gitリポジトリが初期化されました"
fi

# サブモジュールのURL
SUBMODULE_URL="https://github.com/ktanaha/claude-repo.git"
SUBMODULE_PATH="claude-guidelines"

print_info "Claude Code開発ガイドライン統合を開始します..."

# 既存のサブモジュールをチェック
if [ -d "$SUBMODULE_PATH" ]; then
    if [ "$FORCE" = true ]; then
        print_warning "既存のサブモジュール $SUBMODULE_PATH を削除します..."
        git submodule deinit -f "$SUBMODULE_PATH" 2>/dev/null || true
        git rm -f "$SUBMODULE_PATH" 2>/dev/null || true
        rm -rf "$SUBMODULE_PATH"
        rm -rf ".git/modules/$SUBMODULE_PATH"
    else
        print_warning "サブモジュール $SUBMODULE_PATH は既に存在します"
        print_info "強制的に再作成するには --force オプションを使用してください"
        print_info "既存のサブモジュールを更新します..."
        git submodule update --init --recursive "$SUBMODULE_PATH"
    fi
fi

# サブモジュールを追加（存在しない場合のみ）
if [ ! -d "$SUBMODULE_PATH" ]; then
    print_info "サブモジュールを追加しています..."
    git submodule add "$SUBMODULE_URL" "$SUBMODULE_PATH"
    print_success "サブモジュールが追加されました: $SUBMODULE_PATH"
fi

# サブモジュールを初期化・更新
print_info "サブモジュールを初期化・更新しています..."
git submodule init
git submodule update --recursive

# .gitignoreファイルの更新
print_info ".gitignoreファイルを更新しています..."

# .gitignoreファイルが存在しない場合は作成
if [ ! -f ".gitignore" ]; then
    print_info ".gitignoreファイルを作成しています..."
    touch ".gitignore"
fi

# 必要な項目を追加（重複チェック付き）
GITIGNORE_ENTRIES=(
    "# Claude Code設定ファイル"
    "claude.md"
    "CLAUDE.md"
    ""
    "# OS固有ファイル"
    ".DS_Store"
    ".DS_Store?"
    "._*"
    ".Spotlight-V100"
    ".Trashes"
    "ehthumbs.db"
    "Thumbs.db"
    ""
    "# IDE設定"
    ".vscode/"
    ".idea/"
    "*.swp"
    "*.swo"
    "*~"
    ""
    "# ログファイル"
    "*.log"
    "npm-debug.log*"
    "yarn-debug.log*"
    "yarn-error.log*"
)

for entry in "${GITIGNORE_ENTRIES[@]}"; do
    if [ -n "$entry" ] && ! grep -Fxq "$entry" ".gitignore"; then
        echo "$entry" >> ".gitignore"
    elif [ -z "$entry" ] && [ "$(tail -c1 .gitignore)" != "" ]; then
        echo "" >> ".gitignore"
    fi
done

print_success ".gitignoreファイルが更新されました"

# シンボリックリンクの作成
if [ "$NO_LINK" = false ]; then
    print_info "CLAUDE.mdへのシンボリックリンクを作成しています..."
    
    # 既存のCLAUDE.mdをチェック
    if [ -f "CLAUDE.md" ] || [ -L "CLAUDE.md" ]; then
        print_warning "既存のCLAUDE.mdファイルまたはリンクが存在します"
        read -p "上書きしますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -f "CLAUDE.md"
        else
            print_info "シンボリックリンクの作成をスキップします"
            NO_LINK=true
        fi
    fi
    
    if [ "$NO_LINK" = false ]; then
        # 相対パスでシンボリックリンクを作成
        ln -sf "$SUBMODULE_PATH/claude.md" "CLAUDE.md"
        print_success "シンボリックリンクが作成されました: CLAUDE.md -> $SUBMODULE_PATH/claude.md"
    fi
fi

# 完了メッセージ
print_success "Claude Code開発ガイドラインの統合が完了しました！"
echo
print_info "次のステップ:"
echo "  1. git add . && git commit -m 'feat: Claude Code開発ガイドラインを統合'"
echo "  2. 開発を開始する前にCLAUDE.mdの内容を確認してください"
echo "  3. TDD（Red-Green-Refactor）プロセスに従って開発を進めてください"
echo
print_info "サブモジュールの更新方法:"
echo "  git submodule update --remote $SUBMODULE_PATH"
echo
print_info "ガイドラインファイルの場所:"
echo "  - プロジェクトルート: CLAUDE.md (シンボリックリンク)"
echo "  - サブモジュール内: $SUBMODULE_PATH/claude.md"

# ワンライナーでの使用方法を表示
echo
print_info "他のプロジェクトでワンライナーで実行する場合:"
echo "  curl -fsSL https://raw.githubusercontent.com/ktanaha/claude-repo/master/setup.sh | bash"