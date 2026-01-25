#!/usr/bin/env bash
set -euo pipefail

# Install/update dotfiles via git + symlinks.
# - Clones (or updates) the repo into $DOTFILES_DIR (default: ~/.dotfiles)
# - Runs link-dotfiles.sh to refresh symlinks into $HOME

REPO_URL="${REPO_URL:-https://github.com/omihirofumi/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required (install Xcode Command Line Tools or brew install git)" >&2
  exit 1
fi

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "Updating existing dotfiles repo at $DOTFILES_DIR"
  git -C "$DOTFILES_DIR" pull --rebase
elif [[ -e "$DOTFILES_DIR" ]]; then
  echo "$DOTFILES_DIR exists but is not a git repo. Remove it or set DOTFILES_DIR to another path." >&2
  exit 1
else
  echo "Cloning dotfiles into $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

if [[ ! -x ./link-dotfiles.sh ]]; then
  chmod +x ./link-dotfiles.sh
fi

./link-dotfiles.sh
