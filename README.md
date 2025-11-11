# ⚙️ My Dotfiles

My personal configuration files for Zsh, Git, and other tools, managed via symlinks.

## Prerequisites

1.  `git`
2.  `zsh`
3.  [Oh My Zsh](https://ohmyzsh.com/)

## 🚀 Quick Setup

1.  **Clone the repository:**

    ```bash
    # !!! Replace with your own repo URL !!!
    git clone  https://github.com/DayDreammy/dotfiles ~/dotfiles
    ```

2.  **(Optional) Install Zsh Plugins:**
    This config uses `zsh-syntax-highlighting` and `zsh-autosuggestions`.

    ```bash
    git clone [https://github.com/zsh-users/zsh-syntax-highlighting.git](https://github.com/zsh-users/zsh-syntax-highlighting.git) ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

3.  **Run the install script:**
    This will safely back up any existing files and create the necessary symlinks.

    ```bash
    cd ~/dotfiles
    ./install.sh
    ```

4.  **Restart your shell:**
    Close and reopen your terminal or run `exec zsh`.

## 🔧 Management

This repository contains the *source* files (e.g., `zshrc`). The `install.sh` script creates symlinks (e.g., `~/.zshrc`) that point to them.

**To add a new file (e.g., `.vimrc`):**

1.  **Move** the file into this directory: `mv ~/.vimrc ~/dotfiles/vimrc`
2.  **Edit** `install.sh` and add `"vimrc .vimrc"` to the `links` array.
3.  **Run** `./install.sh` again.
4.  **Commit** your changes.

