#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Skip: macOS only."
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) not found. Install gh first." >&2
  exit 1
fi

GH_EXTENSIONS=(
  "dlvhdr/gh-dash"
)

echo "Installing GitHub CLI extensions..."

for extension in "${GH_EXTENSIONS[@]}"; do
  if gh extension list | grep -q "^$extension\\b"; then
    echo "$extension is already installed."
  else
    echo "Installing $extension"
    gh extension install "$extension"
  fi
done

echo "GitHub CLI extensions installation completed."
