# Repository Guidelines

## Project Structure & Module Organization

This repository is a macOS dotfiles and workstation bootstrap setup managed by `mise`. The main entry point is `mise.toml`, which declares Homebrew packages, casks, user defaults, bootstrap tasks, and dotfile symlink mappings. User-facing documentation lives in `README.md`, while `CLAUDE.md` records agent-specific project context.

Managed dotfiles are stored as source files in the repository and linked into the home directory by `mise`. Key paths include `.zshrc`, `.gitconfig`, `.tmux.conf`, `.ideavimrc`, `.config/ghostty/`, `.config/karabiner/`, `.config/helix/`, `.config/jj/`, `.config/jjui/`, `.config/zed/`, and `.local/bin/` helper scripts.

## Build, Test, and Development Commands

- `mise trust`: trust this repository's `mise.toml` before running bootstrap tasks.
- `mise bootstrap --dry-run`: preview package, dotfile, tool, and macOS default changes.
- `mise bootstrap --yes --force-dotfiles --skip packages,tools,task`: apply dotfile links and defaults without installing packages or running tasks.
- `mise bootstrap --yes`: run the full bootstrap, including Homebrew package and cask setup.

There is no application build step in this repository.

## Coding Style & Naming Conventions

Keep configuration files in their native formats: TOML for `mise`, Helix, JJ, and direnv; JSON for Karabiner, Zed, and Oh My Posh; shell for `.zshrc` and scripts in `.local/bin/`. Use two-space indentation for JSON and TOML unless an existing file uses another style. Prefer descriptive lowercase or tool-native names, for example `.config/helix/config.toml` or `.local/bin/hx-typescript-language-server-global`.

## Testing Guidelines

No automated test suite is defined. Validate changes by running `mise bootstrap --dry-run` and checking that the planned links and settings match the intended files. For scripts under `.local/bin/`, run the script directly or invoke its target command in a controlled shell before committing.

## Commit & Pull Request Guidelines

Recent commits use short, lowercase, imperative or topic-style messages such as `zed` and `add dockdoor, remove alt-tab`. Keep commits focused and concise. Pull requests should explain the workstation behavior being changed, list affected tools or dotfiles, and include dry-run output or manual verification notes when bootstrap behavior changes.

## Agent-Specific Instructions

Do not overwrite existing generated or user-managed configuration without checking the target file first. For broad bootstrap changes, prefer documenting the expected `mise bootstrap --dry-run` result before applying changes.
