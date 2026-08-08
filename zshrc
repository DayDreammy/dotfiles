# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# ---------------------------------------------------------------------
# (6) 环境变量配置
# ---------------------------------------------------------------------
# Language and locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# OpenAI API Configuration
export OPENAI_API_KEY="sk-E7moUfIMjdhdDKCfpfuuPGiRr9c5tj3ONbRtZeCFjum0bdQK"
export OPENAI_API_BASE="https://oneapi.daydreammy.xyz/v1"

# Anthropic API Token
export ANTHROPIC_AUTH_TOKEN="d53508e140674ba9900d773872ae914c.51OgDM8faJZMWENu"

# Custom alias for conda
alias conda310="/home/yy/anaconda3/bin/conda"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/yy/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/yy/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/yy/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/yy/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Codex MCP secrets (keep private)
[[ -f "$HOME/.config/codex/secrets.zsh" ]] && source "$HOME/.config/codex/secrets.zsh"

# Add local ffmpeg static build
export PATH=/tmp/ffmpeg-bin:$PATH

# Feishu bot
export FEISHU_WEBHOOK="https://open.feishu.cn/open-apis/bot/v2/hook/32145758-828a-4905-be70-0b756ae464bf"
export FEISHU_KEYWORD="yy"

# opencode
export PATH=/home/yy/.opencode/bin:$PATH
export PATH="$(npm config get prefix)/bin:$PATH"

# SMTP email settings (managed by Codex)
export SMTP_SERVER="smtp.163.com"
export SMTP_PORT="465"
export SMTP_USER="daydreammy@163.com"
export SMTP_PASSWORD="NUYQEBJEHZRHGLSI"
export SMTP_SENDER_EMAIL="daydreammy@163.com"
export SMTP_SENDER_NAME="yi_insight"
export SMTP_RECIPIENTS="1781051483@qq.com"
# End SMTP email settings
