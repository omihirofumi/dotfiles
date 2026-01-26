#!/usr/bin/env bash
set -euo pipefail

hostname="$(scutil --get HostName)"
username="$(id -un)"

sudo USERNAME="$username" HOSTNAME="$hostname" \
  darwin-rebuild switch --flake ".#${hostname}" --impure
