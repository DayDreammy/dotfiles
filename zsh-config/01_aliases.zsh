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
alias condalist='conda env list'
alias condacreate='conda create -n'
alias condactivate='conda activate'

# 系统信息
alias myenv='echo "用户: $(whoami) | 主机: $(hostname) | Shell: $SHELL | Python: $(python3 --version 2>/dev/null || echo "未安装")"'
alias path='echo $PATH | tr ":" "\n"'

# Docker
alias dps='docker ps'
