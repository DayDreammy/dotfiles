#!/bin/bash

# Dotfiles Installation Script
# Automatically creates symbolic links from this repository to your home directory
# with proper backup handling and error checking

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# --- Configuration and Variables ---

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Repository directory (automatically detected)
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOME_DIR="${HOME:-$(eval echo ~$USER)}"
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly BACKUP_DIR="${HOME_DIR}/.dotfiles-backups"

# Logging function
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# --- Helper Functions ---

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate that required directories exist
validate_environment() {
    log "Validating environment..."

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi

    if [[ ! -d "$HOME_DIR" ]]; then
        error "Home directory not found: $HOME_DIR"
        exit 1
    fi

    if [[ ! -w "$HOME_DIR" ]]; then
        error "No write permission to home directory: $HOME_DIR"
        exit 1
    fi

    success "Environment validation passed"
}

# Create backup directory if it doesn't exist
ensure_backup_dir() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        log "Created backup directory: $BACKUP_DIR"
    fi
}

# Backup existing file or link
backup_file() {
    local file_path="$1"
    local backup_name="$(basename "$file_path").bak-${TIMESTAMP}"
    local backup_path="${BACKUP_DIR}/${backup_name}"

    if mv "$file_path" "$backup_path"; then
        warn "Backed up existing file: $file_path -> $backup_path"
        return 0
    else
        error "Failed to backup file: $file_path"
        return 1
    fi
}

# Create symbolic link with error handling
create_link() {
    local source_path="$1"
    local target_path="$2"

    # Check if source file exists
    if [[ ! -e "$source_path" ]]; then
        error "Source file does not exist: $source_path"
        return 1
    fi

    # Check if source file is readable
    if [[ ! -r "$source_path" ]]; then
        error "Source file is not readable: $source_path"
        return 1
    fi

    # Handle existing target
    if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
        # Check if it's already the correct link
        if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == "$source_path" ]]; then
            success "Link already exists and is correct: $target_path"
            return 0
        fi

        # Backup existing file/link
        if ! backup_file "$target_path"; then
            return 1
        fi
    fi

    # Ensure parent directory exists
    local parent_dir
    parent_dir="$(dirname "$target_path")"
    if [[ ! -d "$parent_dir" ]]; then
        if ! mkdir -p "$parent_dir"; then
            error "Failed to create parent directory: $parent_dir"
            return 1
        fi
        log "Created parent directory: $parent_dir"
    fi

    # Create the symbolic link
    if ln -s "$source_path" "$target_path"; then
        success "Created link: $target_path -> $source_path"
        return 0
    else
        error "Failed to create link: $target_path -> $source_path"
        return 1
    fi
}

# Verify created links
verify_links() {
    log "Verifying created links..."
    local failed_count=0

    for item in "${links[@]}"; do
        read -r source target <<< "$item"
        local source_path="$DOTFILES_DIR/$source"
        local target_path="$HOME_DIR/$target"

        if [[ -L "$target_path" ]]; then
            local link_target
            link_target="$(readlink "$target_path")"
            if [[ "$link_target" == "$source_path" ]]; then
                success "✓ $target_path -> $source_path"
            else
                error "✗ $target_path points to wrong target: $link_target"
                ((failed_count++))
            fi
        else
            error "✗ $target_path is not a symbolic link"
            ((failed_count++))
        fi
    done

    if [[ $failed_count -eq 0 ]]; then
        success "All links verified successfully"
        return 0
    else
        error "$failed_count links failed verification"
        return 1
    fi
}

# --- Installation Configuration ---

# Files and directories to link
# Format: "source_file_or_directory target_dotfile_or_directory"
links=(
    "zshrc .zshrc"
    "zshenv .zshenv"
    "zsh-config .zsh-config"
    # Add more entries here as needed:
    # "gitconfig .gitconfig"
    # "vimrc .vimrc"
    # "tmux.conf .tmux.conf"
)

# --- Main Installation Process ---

main() {
    log "Starting dotfiles installation..."
    log "Repository: $DOTFILES_DIR"
    log "Home directory: $HOME_DIR"
    log "Timestamp: $TIMESTAMP"
    echo

    # Validate environment
    validate_environment

    # Ensure backup directory exists
    ensure_backup_dir

    # Count total operations
    local total_links=${#links[@]}
    local current_link=0
    local success_count=0
    local error_count=0

    log "Processing $total_links configuration files..."
    echo

    # Process each link
    for item in "${links[@]}"; do
        ((current_link++))

        read -r source target <<< "$item"
        local source_path="$DOTFILES_DIR/$source"
        local target_path="$HOME_DIR/$target"

        echo "[$current_link/$total_links] Processing: $target"

        if create_link "$source_path" "$target_path"; then
            ((success_count++))
        else
            ((error_count++))
        fi

        echo
    done

    # Verify all created links
    if verify_links; then
        echo
        success "Installation completed successfully!"
        success "Created/updated $success_count links"

        if [[ $error_count -gt 0 ]]; then
            warn "Encountered $error_count errors"
        fi

        # Show backup info if backups were created
        if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
            echo
            log "Backup files are stored in: $BACKUP_DIR"
            log "You can restore them if needed or remove them when you're confident everything works."
        fi

        echo
        log "To apply changes:"
        log "  1. Restart your terminal, or"
        log "  2. Run: exec zsh"

        # Check if Zsh is available and suggest making it default
        if command_exists zsh; then
            local current_shell
            current_shell="$(basename "$SHELL")"
            if [[ "$current_shell" != "zsh" ]]; then
                echo
                warn "Your current shell is $current_shell, not zsh"
                log "To make Zsh your default shell, run:"
                log "  chsh -s \$(which zsh)"
            fi
        else
            echo
            warn "Zsh is not installed. Please install it to use these configurations."
        fi

    else
        echo
        error "Installation completed with errors!"
        error "Successfully created: $success_count links"
        error "Failed to create: $error_count links"
        echo
        log "Please check the error messages above and try running the script again."
        exit 1
    fi
}

# --- Script Entry Point ---

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed directly
    main "$@"
else
    # Script is being sourced
    warn "This script should be executed directly, not sourced."
    warn "Please run: ./install.sh"
    return 1
fi