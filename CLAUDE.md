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
- `home/packages/raycast/script-command/`: Raycast Script Commands, deployed to `~/packages/raycast/script-command/` and registered there as a Raycast script directory. New scripts **must** use the `executable_` prefix — without it chezmoi deploys them 0644 and Raycast cannot run them.
- `home/dot_local/bin/`: Personal scripts, deployed to `~/.local/bin/` (second entry on `PATH`, ahead of `/opt/homebrew/bin`, so a script here shadows a Homebrew binary of the same name). New scripts **must** use the `executable_` prefix — without it chezmoi deploys them 0644 and they cannot be run. Files here have no extension (`herdr-focus-workspace`, not `herdr-focus-workspace.sh`).
- Tool-specific configs: git, zsh, vim, starship, etc.
- `home/dot_config/mise/config.toml`: mise global tool versions (dart, ruby, python) and settings

## Security Constraints

This repository is **public**. Everything under `home/` is world-readable.

`home/dot_claude/modify_settings.json` writes its `MANAGED` keys into `~/.claude/settings.json`, which controls Claude Code's auto-approval behavior. Publishing it hands anyone a map of what runs on this machine without a prompt.

- **`permissions.allow` must contain read-only commands only** (e.g. `gh pr view`, `gh issue list`). Never add write or execute patterns — `git push`, `gh pr create`, `npm run`, `rm`, `chezmoi apply`, etc. A published write-capable allowlist is directly exploitable via prompt injection.
- If a write/execute rule is genuinely needed, keep it out of the repo: rename to `modify_settings.json.tmpl` and source the list from `[data.claude]` in `~/.config/chezmoi/chezmoi.toml` (not version-controlled). Guard it with `{{ if hasKey . "claude" }}` — a missing key is a hard template error, and `default` does not rescue it.
- **`sandbox.excludedCommands` is the same risk class as `permissions.allow`** — it lists commands that run *outside* the sandbox. Claude Code groups it internally with its other sandbox-weakening settings, alongside `autoAllowBashIfSandboxed` and `enableWeakerNestedSandbox`. Before adding an entry, ask whether publishing it hands someone a way to run something unsandboxed on this machine.
- The current entries (`emulator *`, `open -a Simulator*`) are published deliberately: they are guessable from the Flutter/Android toolchain this repo already declares, so the secrecy is not worth what it costs. If a genuinely sensitive entry is ever needed, take the `[data.claude]` route above.
- Never commit `env`, `apiKeyHelper`, or MCP server configs containing tokens. Same for `~/.claude.json`, which holds OAuth tokens and per-project history.
- A service CLI belongs in `permissions.allow` only as individual read-only subcommands (`Bash(gh pr view:*)`), never as the bare CLI (`Bash(gh *)`). It runs with the normal full-privilege login, so the subcommand allowlist *is* the boundary — check every added subcommand for read-only behavior, and never allow one that can print credentials (`gh auth status --show-token`, `gh auth token`).
- Keep `gh api` in `ask`, not `allow`: it can hit any endpoint with any method.
- A read-only-credential wrapper (`gh-ro`, which injected per-org fine-grained PATs) was tried and removed: fine-grained PATs are scoped to a single owner, so each additional org meant another PAT to issue, get approved, rotate, and cache. The only thing it bought over the subcommand allowlist was auto-approved `gh api` GETs.
- op references (`op://Private/...`, `--account my.1password.com`) are safe to commit: they name a vault entry but require a signed-in, unlocked `op` session on the machine to resolve. Never commit the secret material itself.

## Shared ownership of `~/.claude/settings.json`

chezmoi is not the only writer of this file:

- `herdr integration install claude` installs `~/.claude/hooks/herdr-agent-state.sh`
  and registers it as a `hooks.SessionStart` entry.
- Claude Code itself rewrites the file (`/model`, plugin installs, ...) and reorders
  its keys when it does.

So the source is `home/dot_claude/modify_settings.json`, a `modify_` script: chezmoi
feeds it the current file on stdin and writes back what it prints. It never replaces
the file wholesale.

- **Top-level keys** listed in `MANAGED` are replaced as a whole; every other key
  (`model`, anything a single machine added) keeps its current value. `model` is
  deliberately unmanaged so `/model` on each machine sticks.
- **`hooks`** are owned by **command string, never by event name**. Splitting by event
  (chezmoi owns `PreToolUse`, herdr owns `SessionStart`) breaks as soon as either side
  uses the other's event. Keyed on the command, entries from both sides coexist inside
  the same event. herdr's `SessionStart` entry is not in `MANAGED`; herdr owns it.
- **Key order** of the output follows the current file, recursively. Without this,
  Claude Code's reordering alone shows up as `MM` in `chezmoi status` on every write.
- Edit settings by editing the `MANAGED` JSON in the script. `chezmoi add` /
  `re-add` on `~/.claude/settings.json` would replace the script with a plain file.
- Check the result before applying: `chezmoi cat ~/.claude/settings.json`.

**Caveat — removing or renaming something managed leaves the old value behind.** A
removed top-level key is simply no longer touched, and a renamed hook command no longer
matches anything chezmoi owns, so the old entry survives beside the new one. Put the old
key in `RETIRED_KEYS` or the old command in `RETIRED_COMMANDS` for one apply on every
machine, then drop it. `model` sits in `RETIRED_KEYS` since the 2026-09-27 switch to
the script; remove it once every machine has applied, or `/model` stops persisting.

herdr notes:

- `herdr integration status` reports the installed version per agent
  (`claude: current (v10)`, or `outdated (v9 < v10)`). Check it when a hook looks stale.
- Never commit `herdr-agent-state.sh` itself. herdr owns and versions it
  (`HERDR_INTEGRATION_VERSION=` in its header) and overwrites it on update.

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
- **Version management**: mise (`~/.config/mise/config.toml` for global, `.mise.toml` / `.tool-versions` per repo)
- **Shell**: Zsh with starship prompt, sheldon plugin manager
- **Editors**: Vim, VSCode (with extensive extension list)
- **Mobile development**: Android Studio, Flutter/Dart tooling
- **Container tools**: Docker
- **Terminal**: iTerm2, ghostty configs

## Testing

The repository includes GitHub Actions workflow (`.github/workflows/test.yaml`) that tests the installation process on Ubuntu and macOS.