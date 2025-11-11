# ⚙️ My Dotfiles

-  My personal configuration files for Zsh, Git, and other tools, managed via symlinks.

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Setup](#-quick-setup)
- [Project Structure](#-project-structure)
- [Management Guide](#-management-guide)
- [Troubleshooting](#-troubleshooting)

## ✨ Features

- **Modular Zsh Configuration**: Separated into logical files for better organization
- **Oh My Zsh Integration**: Full compatibility with Oh My Zsh framework
- **Safe Installation**: Automatic backup of existing configurations
- **Version Control Ready**: Clean git history with proper .gitignore
- **Cross-Platform**: Works on macOS and Linux

## 📦 Prerequisites

Ensure you have the following installed:

1. **Git** - For cloning and managing the repository
   ```bash
   # Ubuntu/Debian
   sudo apt install git
   # macOS (with Homebrew)
   brew install git
   ```

2. **Zsh** - The shell we're configuring
   ```bash
   # Ubuntu/Debian
   sudo apt install zsh
   # macOS
   brew install zsh
   ```

3. **Oh My Zsh** - The Zsh framework (optional but recommended)
   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

## 🚀 Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/DayDreammy/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 2. Install Recommended Zsh Plugins

This configuration works best with syntax highlighting and autosuggestions:

```bash
# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### 3. Run the Installation Script

The script will:
- ✅ Check for existing files and create backups with timestamps
- ✅ Create symbolic links from dotfiles to your home directory
- ✅ Verify all links are created correctly
- ✅ Skip any files that don't exist in the repository

```bash
./install.sh
```

### 4. Apply Changes

Either restart your terminal or run:

```bash
exec zsh
```

## 📁 Project Structure

```
dotfiles/
├── README.md              # This file
├── install.sh             # Installation script
├── .gitignore            # Git ignore rules
├── zshrc                 # Main Zsh configuration
├── zshenv                # Environment variables
└── zsh-config/           # Modular Zsh configurations
    ├── 01_aliases.zsh    # Command aliases
    ├── 02_functions.zsh  # Custom functions
    ├── 03_prompt.zsh     # Theme and prompt settings
    └── 99_plugins.zsh    # Plugin configurations
```

## 🔧 Management Guide

### Adding New Configuration Files

To add a new dotfile (e.g., `.gitconfig`):

1. **Move the file to the repository:**
   ```bash
   mv ~/.gitconfig ~/dotfiles/gitconfig
   ```

2. **Add it to the install script:**
   Edit `install.sh` and add `"gitconfig .gitconfig"` to the `links` array

3. **Update the repository:**
   ```bash
   git add gitconfig install.sh
   git commit -m "Add gitconfig configuration"
   ```

### Modifying Existing Files

Simply edit the files in the `~/dotfiles` directory. The changes will be immediately available since your home directory contains symlinks to these files.

### Updating on Multiple Machines

```bash
cd ~/dotfiles
git pull origin main
./install.sh  # Safe to run multiple times
```

## 🔍 Configuration Details

### Zsh Configuration

- **`.zshenv`**: Loaded in all Zsh sessions (including scripts). Sets up environment variables.
- **`.zshrc`**: Loaded in interactive sessions. Configures Oh My Zsh and loads modular configs.
- **`zsh-config/`**: Modular configuration files for better organization:
  - `01_aliases.zsh`: Command shortcuts
  - `02_functions.zsh`: Custom shell functions
  - `03_prompt.zsh`: Theme and appearance
  - `99_plugins.zsh`: Plugin settings

## 🛠️ Troubleshooting

### Common Issues

**Issue:** "Permission denied" when running install script
```bash
chmod +x install.sh
./install.sh
```

**Issue:** "command not found: zsh" after installation
```bash
# Make zsh your default shell
chsh -s $(which zsh)
```

**Issue:** Links not working properly
```bash
# Check existing links
ls -la ~/.zshrc ~/.zshenv

# Reinstall if needed
cd ~/dotfiles
./install.sh
```

**Issue:** Oh My Zsh not found
- Ensure Oh My Zsh is installed in `~/.oh-my-zsh`
- If installed elsewhere, update the `ZSH` variable in `zshrc`

### Getting Help

If you encounter issues:

1. Check that all prerequisites are installed
2. Verify the installation completed without errors
3. Ensure Zsh is your default shell: `echo $SHELL`
4. Open an issue on the GitHub repository

---

**Note**: This setup is designed to be safe and idempotent - running the install script multiple times will not cause any issues.
