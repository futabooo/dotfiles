# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). The repository contains configuration files for various development tools and applications, organized to be deployed to the user's home directory.

## Architecture

- **Root directory**: Contains chezmoi configuration and management files
- **`home/`**: Source templates for files that will be installed to `$HOME`
- **`bin/`**: Contains the chezmoi binary for deployment
- **`.chezmoiroot`**: Specifies that `home/` is the source directory
- **Brewfile**: Located at `home/packages/Brewfile` - manages Homebrew packages, casks, and VSCode extensions

## Key Files Structure

- `home/dot_*`: Files that become `.filename` in the home directory
- `home/dot_config/`: Configuration files for `~/.config/`
- Tool-specific configs: git, zsh, vim, starship, etc.
- `home/dot_tool-versions`: ASDF version manager configuration

## Common Commands

### Chezmoi Management
```bash
# Apply changes (deploy dotfiles)
chezmoi apply

# Edit a managed file
chezmoi edit ~/.filename

# Add a new file to chezmoi
chezmoi add ~/.filename

# See what would change
chezmoi diff

# Update from git repo
chezmoi update

# Quick alias (defined in zsh config)
c apply    # same as chezmoi apply
```

### Package Management
```bash
# Install all Homebrew packages
brew bundle --file=home/packages/Brewfile

# Update Brewfile with currently installed packages
brew bundle dump --file=home/packages/Brewfile --force
```

### Installation
```bash
# Fresh install (from README)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply futabooo
```

## Development Tools Configured

The dotfiles configure development environments for:
- **Languages**: Dart (3.6.0), Ruby (3.2.2), Python (3.10, 2.7.18)
- **Version management**: ASDF with .tool-versions
- **Shell**: Zsh with starship prompt, sheldon plugin manager
- **Editors**: Vim, VSCode (with extensive extension list)
- **Mobile development**: Android Studio, Flutter/Dart tooling
- **Container tools**: Docker, Kubernetes CLI
- **Terminal**: iTerm2, ghostty configs

## Testing

The repository includes GitHub Actions workflow (`.github/workflows/test.yaml`) that tests the installation process on Ubuntu and macOS.