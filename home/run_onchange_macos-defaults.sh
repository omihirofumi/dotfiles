#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Skip: macOS only."
  exit 0
fi

echo "Configuring macOS keyboard, Dock, trackpad, and Finder settings..."

defaults write -g ApplePressAndHoldEnabled -bool false

# Dock settings
defaults write NSGlobalDomain autohide -bool true
defaults write com.apple.Dock autohide-delay -float 0

# Trackpad
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 7.0

# Finder
defaults write com.apple.finder AppleShowAllFiles TRUE

killall cfprefsd >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall Finder >/dev/null 2>&1 || true

echo "macOS defaults applied."
