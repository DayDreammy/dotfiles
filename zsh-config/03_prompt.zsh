# ~/.zsh-config/03_prompt.zsh

# 设置 OMZ 主题
# 使用显示用户名和主机名的主题
# "robbyrussell" - 简洁但默认不显示用户名
# "agnoster" - 显示用户名、主机名、路径，需要 Powerline 字体
# "af-magic" - 显示用户名、路径、git状态
# "bira" - 显示用户名、主机名、路径、时间

# 选择一个显示用户名的主题
ZSH_THEME="bira"

# 如果你安装了 Powerlevel10k，也可以使用它（显示用户名）
# 首先需要安装：git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# ZSH_THEME="powerlevel10k/powerlevel10k"

# 自定义提示符设置（如果不想使用OMZ主题）
# 取消注释下面这几行来自定义提示符
# PROMPT='%F{cyan}%n@%m%f:%F{green}%~%f$ '
# RPROMPT='%F{yellow}%T%f'
