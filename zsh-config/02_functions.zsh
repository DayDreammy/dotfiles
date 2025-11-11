# ~/.zsh-config/02_functions.zsh
# 存放自定义函数

# 创建目录并立即进入
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 最佳实践：懒加载 (Lazy Load) nvm (Node 版本管理器)
# 这可以防止 nvm 拖慢所有 Zsh 实例的启动速度
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # 加载 nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
