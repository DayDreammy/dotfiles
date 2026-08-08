# ~/.zshenv
# (这个文件在所有 Zsh 实例中加载, 包括脚本)

# 基础系统路径
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin"

# 添加用户级bin目录
export PATH="$HOME/.local/bin:$PATH"

# Python 兼容性 - 创建python命令的软链接或别名
if command -v python3 >/dev/null 2>&1; then
    alias python='python3'
fi

# Conda belongs in ~/.zshrc for interactive shells only.
# ~/.zshenv is loaded by every zsh process, including scripts and command
# substitutions, so running conda hooks here can print warnings on every shell.

# Go 路径 (如果存在)
if [ -d "$HOME/go" ]; then
    export PATH="$PATH:$HOME/go/bin"
fi

# Rust 路径 (如果存在)
if [ -d "$HOME/.cargo" ]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

# 设置默认编辑器
export EDITOR='vim'

# 设置语言环境
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
