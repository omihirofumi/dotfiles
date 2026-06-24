# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A mise bootstrap-based dotfiles/workstation configuration for macOS.
Nix is intentionally not used in this repository.

## Key Commands

```sh
# Apply dotfiles, Homebrew packages/casks, tools, and macOS user defaults
mise bootstrap --yes --force-dotfiles

# Preview bootstrap changes
mise bootstrap --dry-run
```

## Architecture

- **`mise.toml`** — Entry point. Declares bootstrap packages, dotfiles, macOS defaults, and bootstrap tasks.
- **`home/`** — Repo-managed dotfile sources linked by mise:
  - `.zshrc`, `.gitconfig`, `.tmux.conf`, `direnv.toml`
  - `ghostty/`, `karabiner/`, `helix/`, `jj/`, `jjui/`
  - `claude/`, `codex/`, `.ideavimrc`, `negligible.omp.json`
  - `bin/` helper scripts linked into `~/.local/bin`
