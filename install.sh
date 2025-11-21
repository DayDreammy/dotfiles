#!/bin/bash

# Dotfiles Installation Script
# Automatically creates symbolic links from this repository to your home directory
# with proper backup handling and error checking

# More robust error handling - exit on errors but handle undefined vars gracefully
set -eo pipefail
shopt -s inherit_errexit 2>/dev/null || true  # Available in Bash 4.4+

# --- Configuration and Variables ---

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Repository directory (automatically detected)
DOTFILES_DIR=""
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || {
    echo "[ERROR] Failed to determine dotfiles directory" >&2
    exit 1
}
readonly DOTFILES_DIR

# Home directory detection with fallbacks
HOME_DIR="${HOME:-}"
if [[ -z "$HOME_DIR" ]]; then
    HOME_DIR="$(eval echo ~$USER 2>/dev/null)" || {
        echo "[ERROR] Failed to determine home directory" >&2
        exit 1
    }
fi
readonly HOME_DIR

# Generate timestamp safely
TIMESTAMP=""
TIMESTAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null)" || {
    TIMESTAMP="$(printf '%d' "$(date +%s 2>/dev/null || echo 0)")"
}
readonly TIMESTAMP

readonly BACKUP_DIR="${HOME_DIR}/.dotfiles-backups"

# Logging functions with error handling
log() {
    # Check if color codes are supported
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        echo -e "${BLUE}[INFO]${NC} $1"
    else
        echo "[INFO] $1"
    fi
}

warn() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        echo -e "${YELLOW}[WARN]${NC} $1"
    else
        echo "[WARN] $1"
    fi
}

error() {
    if [[ -t 2 ]] && command -v tput >/dev/null 2>&1; then
        echo -e "${RED}[ERROR]${NC} $1" >&2
    else
        echo "[ERROR] $1" >&2
    fi
}

success() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        echo -e "${GREEN}[SUCCESS]${NC} $1"
    else
        echo "[SUCCESS] $1"
    fi
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

# Backup existing file or link with enhanced error handling
backup_file() {
    local file_path="$1"
    local backup_name=""
    local backup_path=""

    # Validate input parameter
    if [[ -z "$file_path" ]]; then
        error "backup_file: file_path parameter is empty"
        return 1
    fi

    backup_name="$(basename "$file_path").bak-${TIMESTAMP}"
    backup_path="${BACKUP_DIR}/${backup_name}"

    # Check if source file exists
    if [[ ! -e "$file_path" ]] && [[ ! -L "$file_path" ]]; then
        warn "Source file does not exist, skipping backup: $file_path"
        return 0
    fi

    # Ensure backup directory exists
    if [[ ! -d "$BACKUP_DIR" ]]; then
        if ! mkdir -p "$BACKUP_DIR"; then
            error "Failed to create backup directory: $BACKUP_DIR"
            return 1
        fi
    fi

    # Check if backup already exists
    if [[ -e "$backup_path" ]]; then
        local counter=1
        while [[ -e "${backup_path}.${counter}" ]]; do
            ((counter++))
        done
        backup_path="${backup_path}.${counter}"
    fi

    if mv "$file_path" "$backup_path"; then
        warn "Backed up existing file: $file_path -> $backup_path"
        return 0
    else
        error "Failed to backup file: $file_path"
        return 1
    fi
}

# Create symbolic link with enhanced error handling
create_link() {
    local source_path="$1"
    local target_path="$2"
    local parent_dir=""
    local link_target=""

    # Validate input parameters
    if [[ -z "$source_path" ]] || [[ -z "$target_path" ]]; then
        error "create_link: source_path or target_path parameter is empty"
        return 1
    fi

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
        if [[ -L "$target_path" ]]; then
            link_target="$(readlink "$target_path" 2>/dev/null || echo "")"
            if [[ "$link_target" == "$source_path" ]]; then
                success "Link already exists and is correct: $target_path"
                return 0
            fi
        fi

        # Backup existing file/link
        if ! backup_file "$target_path"; then
            return 1
        fi
    fi

    # Ensure parent directory exists
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

# Verify created links with enhanced error handling
verify_links() {
    log "Verifying created links..."
    local failed_count=0
    local total_links=0

    # Check if links array is defined and not empty
    if [[ ! -v links ]] || [[ ${#links[@]} -eq 0 ]]; then
        warn "No links defined for verification"
        return 0
    fi

    for item in "${links[@]}"; do
        total_links=$((total_links + 1))

        # Validate item format
        if [[ -z "$item" ]]; then
            error "Empty link configuration found"
            failed_count=$((failed_count + 1))
            continue
        fi

        read -r source target <<< "$item"
        local source_path="$DOTFILES_DIR/$source"
        local target_path="$HOME_DIR/$target"
        local link_target=""

        # Validate paths
        if [[ -z "$source" ]] || [[ -z "$target" ]]; then
            error "Invalid link format: '$item' (missing source or target)"
            failed_count=$((failed_count + 1))
            continue
        fi

        if [[ -L "$target_path" ]]; then
            link_target="$(readlink "$target_path" 2>/dev/null || echo "READ_ERROR")"
            if [[ "$link_target" == "$source_path" ]]; then
                success "✓ $target_path -> $source_path"
            else
                if [[ "$link_target" == "READ_ERROR" ]]; then
                    error "✗ $target_path is a broken link"
                else
                    error "✗ $target_path points to wrong target: $link_target"
                fi
                failed_count=$((failed_count + 1))
            fi
        else
            error "✗ $target_path is not a symbolic link"
            failed_count=$((failed_count + 1))
        fi
    done

    if [[ $failed_count -eq 0 ]]; then
        success "All $total_links links verified successfully"
        return 0
    else
        error "$failed_count out of $total_links links failed verification"
        return 1
    fi
}

# --- Installation Configuration ---

# Files and directories to link
# Format: "source_file_or_directory target_dotfile_or_directory"
# Make sure each entry has both source and target separated by space
declare -a links=(
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

    # Count total operations with safety check
    local total_links=0
    if [[ -v links ]] && [[ ${#links[@]} -gt 0 ]]; then
        total_links=${#links[@]}
    fi

    local current_link=0
    local success_count=0
    local error_count=0

    if [[ $total_links -eq 0 ]]; then
        warn "No configuration files to process"
        return 0
    fi

    log "Processing $total_links configuration files..."
    echo

    # Process each link with enhanced error handling
    for item in "${links[@]}"; do
        # Safely increment current_link
        current_link=$((current_link + 1))

        # Skip empty items
        if [[ -z "$item" ]]; then
            warn "[$current_link/$total_links] Skipping empty configuration entry"
            error_count=$((error_count + 1))
            echo
            continue
        fi

        read -r source target <<< "$item"
        local source_path="$DOTFILES_DIR/$source"
        local target_path="$HOME_DIR/$target"

        # Validate configuration entry
        if [[ -z "$source" ]] || [[ -z "$target" ]]; then
            error "[$current_link/$total_links] Invalid configuration entry: '$item'"
            error_count=$((error_count + 1))
            echo
            continue
        fi

        echo "[$current_link/$total_links] Processing: $target"

        if create_link "$source_path" "$target_path"; then
            success_count=$((success_count + 1))
        else
            error_count=$((error_count + 1))
        fi

        echo
    done

    # Verify all created links
    if verify_links; then
        echo
        success "Installation completed successfully!"
        success "Created/updated $success_count links"

        if [[ $error_count -gt 0 ]]; then
            warn "Encountered $error_count errors during processing"
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
            local current_shell=""
            current_shell="$(basename "${SHELL:-/bin/sh}" 2>/dev/null || echo "unknown")"
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

        return 0
    else
        echo
        error "Installation completed with errors!"
        error "Successfully created: $success_count links"
        error "Failed to create: $error_count links"
        echo
        log "Please check the error messages above and try running the script again."
        return 1
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