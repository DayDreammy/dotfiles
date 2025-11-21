# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles management system that uses symbolic links to maintain configuration files across multiple machines. The system is designed for Unix-like environments (Linux/macOS) and focuses on Zsh configuration with modular organization.

## Core Architecture

### Symbolic Link Management
- Configuration files are stored in this repository (`~/dotfiles`)
- The `install.sh` script creates symbolic links from `HOME` directory to repository files
- Existing configurations are automatically backed up to `~/.dotfiles-backups/` with timestamps
- The installation is idempotent - safe to run multiple times

### Modular Zsh Configuration
The Zsh configuration is split into logical modules in the `zsh-config/` directory:

- **`zshenv`**: Environment variables (loaded in all Zsh sessions)
- **`zshrc`**: Main interactive configuration (loads modules and Oh My Zsh)
- **`zsh-config/01_aliases.zsh`**: Command aliases and shortcuts
- **`zsh-config/02_functions.zsh`**: Custom shell functions
- **`zsh-config/03_prompt.zsh`**: Theme and prompt settings
- **`zsh-config/99_plugins.zsh`**: Plugin configurations

Loading order: `.zshenv` → `.zshrc` → pre-OMZ modules → Oh My Zsh → post-OMZ modules

### DevDocs Workflow
This repository uses a "Context Engineering Protocol" with three core documents:
- **`plan.md`**: Project goals and current phase (strategic direction)
- **`context.md`**: Technical decisions and lessons learned (knowledge base)
- **`tasks.md`**: Current task tracking (execution status)

These documents serve as external working memory to maintain context across sessions.

## Common Commands

### Installation and Setup
```bash
# Initial repository setup
git clone https://github.com/DayDreammy/dotfiles ~/dotfiles
cd ~/dotfiles

# Install Zsh plugins (required for configuration)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Run installation script
./install.sh

# Apply changes
exec zsh
```

### Adding New Configuration Files
To add a new dotfile (e.g., `.gitconfig`):
1. Move existing file to repository: `mv ~/.gitconfig ~/dotfiles/gitconfig`
2. Add entry to `links` array in `install.sh`: `"gitconfig .gitconfig"`
3. Commit changes: `git add gitconfig install.sh && git commit -m "Add gitconfig"`

### Updating on Multiple Machines
```bash
cd ~/dotfiles
git pull origin main
./install.sh  # Safe to re-run
```

### Testing and Validation
The installation script includes built-in verification:
```bash
# Run installation with verification
./install.sh

# Manually check specific links
ls -la ~/.zshrc ~/.zshenv ~/.zsh-config/
```

## Important Technical Constraints

- **Repository Location**: Must be cloned to `~/dotfiles` for symbolic links to work correctly
- **Oh My Zsh Dependency**: Requires Oh My Zsh installed in `~/.oh-my-zsh`
- **Shell Requirements**: Zsh 5.0+, Bash 4.0+, Git 2.0+
- **Platform Support**: Ubuntu/Debian and macOS (CentOS/RHEL untested)
- **Permission Requirements**: Write access to HOME directory

## File Structure and Conventions

### Configuration Loading Strategy
- Environment variables in `.zshenv` (universal, non-interactive)
- Oh My Zsh integration in `.zshrc` with module loading before/after OMZ
- Numbered prefix in module filenames (`01_`, `02_`, etc.) controls loading order
- Optional file loading with existence checks: `[ -f "$path" ] && source "$path"`

### Installation Script Patterns
- Uses Bash arrays for link configuration: `"source_file target_dotfile"`
- Robust error handling with `set -eo pipefail`
- Colored output for logging (INFO, WARN, ERROR, SUCCESS)
- Atomic backup with timestamp naming
- Link validation to verify installation success

### Git Workflow
- Main branch: `main`
- Commit messages follow conventional format
- `.gitignore` excludes DevDocs files, backups, and temporary files
- Version control only manages source files, not the symbolic links

## Development Guidelines

When working with this repository:

1. **Preserve Idempotency**: Installation script must remain safe to run multiple times
2. **Maintain Modularity**: Keep Zsh configurations in separate, logically organized files
3. **Update Documentation**: Keep DevDocs files current with any architectural changes
4. **Test Cross-Platform**: Ensure changes work on both Linux and macOS when possible
5. **Backup Safety**: Never modify the backup mechanism - it's critical for user safety

## Context Engineering Protocol Usage

When making changes:
1. Check `plan.md` to ensure alignment with current project phase
2. Read `context.md` to understand established technical decisions and constraints
3. Update `tasks.md` to track progress on specific implementation tasks
4. Document new lessons learned in `context.md` to prevent future mistakes