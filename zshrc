# ~/.zshrc
# (这个文件只在交互式 Shell 中加载)

# ---------------------------------------------------------------------
# (1) Oh My Zsh 核心路径
# ---------------------------------------------------------------------
# 如果你的 OMZ 安装在其他地方, 请修改这里
export ZSH="$HOME/.oh-my-zsh"

# ---------------------------------------------------------------------
# (2) 定义你的个人配置仓库目录
# ---------------------------------------------------------------------
export ZSH_CONFIG_DIR="$HOME/.zsh-config"

# ---------------------------------------------------------------------
# (3) 加载你的个人配置 (在 OMZ 启动前加载)
# ---------------------------------------------------------------------
# 主题(Prompt)和插件(Plugins)列表必须在 source $ZSH/oh-my-zsh.sh 之前定义

# 加载主题设置
[ -f "$ZSH_CONFIG_DIR/03_prompt.zsh" ] && source "$ZSH_CONFIG_DIR/03_prompt.zsh"

# 加载插件列表
[ -f "$ZSH_CONFIG_DIR/99_plugins.zsh" ] && source "$ZSH_CONFIG_DIR/99_plugins.zsh"

# ---------------------------------------------------------------------
# (4) 启动 Oh My Zsh
# ---------------------------------------------------------------------
# (可选) 减少 "insecure directories" 警告, 提高启动速度
ZSH_DISABLE_COMPFIX="true"
source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------------------------
# (5) 加载 OMZ 启动后才生效的配置 (别名, 函数)
# ---------------------------------------------------------------------
# 加载别名
[ -f "$ZSH_CONFIG_DIR/01_aliases.zsh" ] && source "$ZSH_CONFIG_DIR/01_aliases.zsh"

# 加载函数
[ -f "$ZSH_CONFIG_DIR/02_functions.zsh" ] && source "$ZSH_CONFIG_DIR/02_functions.zsh"

# (可选) 自动补全初始化
# OMZ 通常会处理, 但如果补全有问题, 取消下面两行的注释
# autoload -Uz compinit
# compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
