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
- `home/dot_local/bin/`: Personal scripts, deployed to `~/.local/bin/` (second entry on `PATH`, ahead of `/opt/homebrew/bin`, so a script here shadows a Homebrew binary of the same name). New scripts **must** use the `executable_` prefix — without it chezmoi deploys them 0644 and they cannot be run. Files here have no extension (`gh-ro`, not `gh-ro.sh`).
- Tool-specific configs: git, zsh, vim, starship, etc.
- `home/dot_config/mise/config.toml`: mise global tool versions (dart, ruby, python) and settings

## Security Constraints

This repository is **public**. Everything under `home/` is world-readable.

`home/dot_claude/settings.json` deploys to `~/.claude/settings.json`, which controls Claude Code's auto-approval behavior. Publishing it hands anyone a map of what runs on this machine without a prompt.

- **`permissions.allow` must contain read-only commands only** (e.g. `gh pr view`, `gh issue list`). Never add write or execute patterns — `git push`, `gh pr create`, `npm run`, `rm`, `chezmoi apply`, etc. A published write-capable allowlist is directly exploitable via prompt injection.
- If a write/execute rule is genuinely needed, keep it out of the repo: rename to `settings.json.tmpl` and source the list from `[data.claude]` in `~/.config/chezmoi/chezmoi.toml` (not version-controlled). Guard it with `{{ if hasKey . "claude" }}` — a missing key is a hard template error, and `default` does not rescue it.
- **`sandbox.excludedCommands` is the same risk class as `permissions.allow`** — it lists commands that run *outside* the sandbox. Claude Code groups it internally with its other sandbox-weakening settings, alongside `autoAllowBashIfSandboxed` and `enableWeakerNestedSandbox`. Before adding an entry, ask whether publishing it hands someone a way to run something unsandboxed on this machine.
- The current entries (`emulator *`, `open -a Simulator*`) are published deliberately: they are guessable from the Flutter/Android toolchain this repo already declares, so the secrecy is not worth what it costs. The cost is concrete — moving `settings.json` to a template breaks the `chezmoi add` step documented below in *Shared ownership of `~/.claude/settings.json`*, because chezmoi's `re-add` does not work with templates and `chezmoi add` would overwrite the template with literal content, losing the `{{ if hasKey . "claude" }}` guard. If a genuinely sensitive entry is ever needed, take the `[data.claude]` route anyway and switch that step to `chezmoi merge`.
- Never commit `env`, `apiKeyHelper`, or MCP server configs containing tokens. Same for `~/.claude.json`, which holds OAuth tokens and per-project history.
- The readonly wrappers in `home/dot_local/bin/` (`gh-ro`, and later `wrangler-ro` / `firebase-ro`) are the only way a service CLI belongs in `permissions.allow` — as `Bash(gh-ro:*)`, never as `Bash(gh *)`. 1Password is the source of truth for the read-only credential; `gh-ro` reads it via `op` at run time, so no secret is committed. `gh-ro` also caches that same credential in the macOS login Keychain (`gh-ro --setup`, service `gh-ro:github.com`) so it still works when `op` can't reach the 1Password desktop app — inside the Claude Code sandbox, or during Remote Control while 1Password is locked; the Keychain entry is a machine-local copy of the same read-only PAT, not a separate secret, and nothing keychain-related is ever committed. Their effective boundary is the credential's scope, not the in-script allowlist or where the credential is cached; treat the allowlist as accident prevention only. **This is not a sandbox** — the agent can still invoke plain `gh` directly.
- op references (`op://Private/...`, `--account my.1password.com`, the work account ID) are safe to commit: they name a vault entry but require a signed-in, unlocked `op` session on the machine to resolve. Never commit the secret material itself.

## Shared ownership of `~/.claude/settings.json`

chezmoi is not the only writer of this file. `herdr integration install claude`
installs `~/.claude/hooks/herdr-agent-state.sh` and registers it as a
`hooks.SessionStart` entry in `~/.claude/settings.json`.

Because chezmoi replaces the file wholesale, `chezmoi apply` silently reverts
whatever herdr just wrote. Observed 2026-09-22: upgrading the integration from v9
to v10 narrowed the `SessionStart` matcher from `"*"` to
`"^(startup|resume|clear|compact|fork)$"`, and `chezmoi status` then reported
`MM .claude/settings.json`. Applying at that point would have thrown the upgrade away.

- After `herdr integration install claude`, run `chezmoi add ~/.claude/settings.json`
  before the next `chezmoi apply`.
- `herdr integration status` reports the installed version per agent
  (`claude: current (v10)`, or `outdated (v9 < v10)`). Check it when a hook looks stale.
- Never commit `herdr-agent-state.sh` itself. herdr owns and versions it
  (`HERDR_INTEGRATION_VERSION=` in its header) and overwrites it on update.

### If this moves to a `modify_` script

The structural fix is `home/dot_claude/modify_settings.json.tmpl`: chezmoi stops
replacing the file and instead merges its own keys into whatever is already there,
leaving herdr's entries — and any hook added by hand on a single machine — untouched.

Decide ownership by **command string, never by event name**. Splitting `hooks` by
event (chezmoi owns `PreToolUse`, herdr owns `SessionStart`) breaks as soon as either
side starts using the other's event. Keyed on the command, entries from both sides
coexist inside the same event:

```jq
($managed | [ .[][] | .hooks[].command ]) as $owned
```

**Caveat — renaming a managed command orphans the old entry.** The previous command
string no longer matches anything chezmoi owns, so it survives the merge and the new
entry is appended beside it, leaving both registered. When changing a hook's command,
keep the old string in the owned list for one apply, then drop it.

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