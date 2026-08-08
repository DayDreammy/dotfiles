# ~/.zsh-config/01_aliases.zsh
# 存放所有别名

alias zshconfig="code ~/.zsh-config"
alias zshrc="code ~/.zshrc"
alias zshenv="code ~/.zshenv"

# ls
alias l='ls -lAh'
alias ll='ls -lAh'
alias la='ls -A'
alias lsa='ls -la'

# Git
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gs='git status'
alias gco='git checkout'
alias gb='git branch'

# Python 和 Conda 别名
alias py='python3'
alias pip='pip3'

# Conda 主安装 (fix for multiple conda installations)
# Note: conda is now handled by conda init in .zshrc
alias conda310='/home/yy/anaconda3/bin/conda'
alias condalist='/home/yy/anaconda3/bin/conda env list'
alias condacreate='/home/yy/anaconda3/bin/conda create -n'
alias condactivate='source /home/yy/anaconda3/bin/activate'

# 常用 conda 命令快捷方式
alias py310='conda activate py310'
alias lsenv='conda env list'
alias mkenv='conda create -n'

# 系统信息
alias myenv='echo "用户: $(whoami) | 主机: $(hostname) | Shell: $SHELL | Python: $(python3 --version 2>/dev/null || echo "未安装")"'
alias path='echo $PATH | tr ":" "\n"'

# Docker
alias dps='docker ps'
