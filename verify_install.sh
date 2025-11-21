#!/bin/bash

echo "=== Dotfiles 安装验证脚本 ==="
echo
echo "✅ 验证修复后的环境配置"
echo

# 1. 验证符号链接
echo "1. 符号链接验证:"
if [ -L "$HOME/.zshenv" ] && [ -L "$HOME/.zshrc" ]; then
    echo "   ✅ Zsh配置文件链接正确"
else
    echo "   ❌ Zsh配置文件链接有问题"
fi

if [ -d "$HOME/.zsh-config" ]; then
    echo "   ✅ Zsh模块配置目录存在"
else
    echo "   ❌ Zsh模块配置目录不存在"
fi
echo

# 2. 验证Python环境
echo "2. Python环境验证:"
if command -v python >/dev/null 2>&1; then
    echo "   ✅ python命令: $(python --version 2>&1)"
else
    echo "   ❌ python命令未找到"
fi

if command -v python3 >/dev/null 2>&1; then
    echo "   ✅ python3命令: $(python3 --version 2>&1)"
else
    echo "   ❌ python3命令未找到"
fi
echo

# 3. 验证Conda环境
echo "3. Conda环境验证:"
if command -v conda >/dev/null 2>&1; then
    echo "   ✅ conda命令: $(conda --version 2>&1)"
    if [ -n "$CONDA_PREFIX" ]; then
        echo "   ✅ Conda前缀: $CONDA_PREFIX"
    fi
else
    echo "   ❌ conda命令未找到"
fi
echo

# 4. 验证主题配置
echo "4. Zsh主题配置:"
echo "   当前主题: ${ZSH_THEME:-未加载}"
if [ -f "$HOME/.zsh-config/03_prompt.zsh" ]; then
    echo "   ✅ 主题配置文件存在"
fi
echo

echo "=== 使用说明 ==="
echo "要完全应用所有更改，请运行以下命令之一："
echo "1. 重启终端"
echo "2. 或者运行: exec zsh"
echo
echo "应用更改后，你应该能看到："
echo "- 用户名和主机名在提示符中"
echo "- python 和 conda 命令可用"
echo -"py 和 myenv 别名可用"