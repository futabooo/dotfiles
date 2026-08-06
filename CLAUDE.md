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

## Security Constraints

This repository is **public**. Everything under `home/` is world-readable.

`home/dot_claude/settings.json` deploys to `~/.claude/settings.json`, which controls Claude Code's auto-approval behavior. Publishing it hands anyone a map of what runs on this machine without a prompt.

- **`permissions.allow` must contain read-only commands only** (e.g. `gh pr view`, `gh issue list`). Never add write or execute patterns — `git push`, `gh pr create`, `npm run`, `rm`, `chezmoi apply`, etc. A published write-capable allowlist is directly exploitable via prompt injection.
- If a write/execute rule is genuinely needed, keep it out of the repo: rename to `settings.json.tmpl` and source the list from `[data.claude]` in `~/.config/chezmoi/chezmoi.toml` (not version-controlled). Guard it with `{{ if hasKey . "claude" }}` — a missing key is a hard template error, and `default` does not rescue it.
- Never commit `env`, `apiKeyHelper`, or MCP server configs containing tokens. Same for `~/.claude.json`, which holds OAuth tokens and per-project history.

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