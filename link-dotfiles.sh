#!/usr/bin/env bash
set -euo pipefail

# Symlink dotfiles from this repo's home/ tree (dot_/private_ naming) into $HOME.
# Use --list to see what would be linked without making changes.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="${SOURCE_ROOT:-"$SCRIPT_DIR/home"}"
TARGET_HOME="${TARGET_HOME:-"$HOME"}"

if [[ ! -d "$SOURCE_ROOT" ]]; then
  echo "home/ not found at $SOURCE_ROOT" >&2
  exit 1
fi

list_only=false
if [[ "${1:-}" == "--list" ]]; then
  list_only=true
fi

normalize_component() {
  local name="$1"
  while :; do
    if [[ "$name" == private_* ]]; then
      name="${name#private_}"
      continue
    fi
    if [[ "$name" == dot_* ]]; then
      name=".${name#dot_}"
      continue
    fi
    break
  done
  printf '%s' "$name"
}

map_path() {
  local rel="$1"
  local parts=()
  local normalized=()

  IFS='/' read -r -a parts <<<"$rel"
  for part in "${parts[@]}"; do
    normalized+=( "$(normalize_component "$part")" )
  done

  local IFS='/'
  local joined="${normalized[*]}"
  printf '%s\n' "$joined"
}

while IFS= read -r rel; do
  dest_rel="$(map_path "$rel")"
  src="$SOURCE_ROOT/$rel"
  dest="$TARGET_HOME/$dest_rel"

  if $list_only; then
    printf '%s -> %s\n' "$rel" "$dest_rel"
    continue
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    backup="${dest}.bak.$(date +%s)"
    echo "Backing up $dest to $backup"
    mv "$dest" "$backup"
  fi

  ln -snf "$src" "$dest"
done < <(
  cd "$SOURCE_ROOT" && \
    find . -type f ! -name '*.tmpl' ! -name '.DS_Store' -print \
    | sed 's|^./||' \
    | sort
)

if $list_only; then
  exit 0
fi

echo "Symlinks refreshed into $TARGET_HOME"
