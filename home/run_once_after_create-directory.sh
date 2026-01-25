#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Skip: macOS only."
  exit 0
fi

dirs=(
  "$HOME/Development"
)

echo "Creating directories: ${dirs[*]}"
mkdir -p "${dirs[@]}"
