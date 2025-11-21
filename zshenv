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

# Conda 环境初始化 - 检查常见的conda安装位置
__conda_setup=""
# 检查项目目录中的conda
if [ -d "/home/yy/project/kotaemon/kotaemon-app/install_dir/conda" ]; then
    CONDA_PREFIX="/home/yy/project/kotaemon/kotaemon-app/install_dir/conda"
    export PATH="$CONDA_PREFIX/bin:$PATH"
    __conda_setup="$($CONDA_PREFIX/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
fi

# 检查用户目录中的conda
if [ -z "$__conda_setup" ] && [ -d "$HOME/anaconda3" ]; then
    CONDA_PREFIX="$HOME/anaconda3"
    export PATH="$CONDA_PREFIX/bin:$PATH"
    __conda_setup="$($CONDA_PREFIX/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
fi

if [ -z "$__conda_setup" ] && [ -d "$HOME/miniconda3" ]; then
    CONDA_PREFIX="$HOME/miniconda3"
    export PATH="$CONDA_PREFIX/bin:$PATH"
    __conda_setup="$($CONDA_PREFIX/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
fi

# 如果找到conda，则初始化
if [ -n "$__conda_setup" ]; then
    eval "$__conda_setup"
else
    if command -v conda >/dev/null 2>&1; then
        \conda init zsh
    fi
fi

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
