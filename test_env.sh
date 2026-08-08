#!/bin/bash
echo "=== 完全重新加载Zsh环境测试 ==="
echo

# 启动新的zsh会话来测试完整配置
zsh -c "
echo '1. 用户信息:'
echo \"   用户: \$(whoami)\"
echo \"   主机: \$(hostname)\"
echo

echo '2. Shell环境:'
echo \"   当前Shell: \$SHELL\"
echo \"   Zsh版本: \$ZSH_VERSION\"
echo

echo '3. Python环境:'
if command -v python >/dev/null 2>&1; then
    echo \"   Python: \$(python --version 2>&1)\"
else
    echo \"   Python: 未找到\"
fi

if command -v python3 >/dev/null 2>&1; then
    echo \"   Python3: \$(python3 --version 2>&1)\"
else
    echo \"   Python3: 未找到\"
fi
echo

echo '4. Conda环境:'
if command -v conda >/dev/null 2>&1; then
    echo \"   Conda: \$(conda --version 2>&1)\"
    echo \"   Conda前缀: \${CONDA_EXE:-未设置}\"
else
    echo \"   Conda: 未找到\"
fi
echo

echo '5. PATH检查 (前10个):'
echo \"\$PATH\" | tr ':' '\n' | head -10
echo

echo '6. 别名检查:'
if alias py >/dev/null 2>&1; then
    echo \"   py别名: \$(alias py)\"
else
    echo '   py别名: 未设置'
fi

if alias myenv >/dev/null 2>&1; then
    echo \"   myenv别名: 已设置\"
else
    echo '   myenv别名: 未设置'
fi
echo

echo '7. Oh My Zsh状态:'
if [ -n \"\$ZSH\" ]; then
    echo \"   Oh My Zsh路径: \$ZSH\"
    echo \"   主题: \$ZSH_THEME\"
else
    echo '   Oh My Zsh: 未加载'
fi
"