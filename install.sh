#!/bin/bash

# dotfiles 安装脚本
# 自动创建从 $HOME/dotfiles 到 $HOME 的符号链接

# --- 配置 ---

# 仓库目录 (自动获取脚本所在的目录)
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Home 目录
HOME_DIR="$HOME"

# 时间戳, 用于备份
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# 要链接的配置文件列表
# 格式: "仓库中的源文件/目录   Home目录中的目标链接"
links=(
    "zshrc .zshrc"
    "zshenv .zshenv"
    "zsh-config .zsh-config"
    # 示例：未来你可以添加更多...
    # "gitconfig .gitconfig"
    # "vimrc .vimrc"
)


# --- 脚本开始 ---

echo "🚀 开始安装 Dotfiles..."
echo "仓库目录: $DOTFILES_DIR"
echo "Home 目录:  $HOME_DIR"
echo ""

# 遍历列表并创建链接
for item in "${links[@]}"; do
    # 将 "source target" 字符串拆分为两个变量
    read -r source target < <(echo "$item")

    source_path="$DOTFILES_DIR/$source"
    target_path="$HOME_DIR/$target"

    echo "-------------------------------"
    echo "🔗 正在处理 $target..."

    # 1. 检查源文件是否存在
    if [ ! -e "$source_path" ]; then
        echo "❌ 错误: 源文件 $source_path 不存在。已跳过。"
        continue
    fi

    # 2. 检查目标是否已存在
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        
        # 3. 检查是否已经是正确的链接
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" == "$source_path" ]; then
            echo "✅ 链接已存在且正确。无需操作。"
        else
            # 4. 备份现有文件/链接
            backup_path="$target_path.bak-$TIMESTAMP"
            echo "⚠️  警告: $target_path 已存在。"
            mv "$target_path" "$backup_path"
            echo "🛡️  已备份到 $backup_path"

            # 5. 创建新链接
            ln -s "$source_path" "$target_path"
            echo "✅ 已创建新链接: $target_path -> $source_path"
        fi
    else
        # 6. 目标不存在, 直接创建
        echo "Creating link: $target_path -> $source_path"
        ln -s "$source_path" "$target_path"
        echo "✅ 链接已创建。"
    fi
done

echo ""
echo "-------------------------------"
echo "🎉 Dotfiles 安装完成!"
