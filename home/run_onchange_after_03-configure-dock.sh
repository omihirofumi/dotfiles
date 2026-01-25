#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Skip: macOS only."
  exit 0
fi

if ! command -v dockutil >/dev/null 2>&1; then
  echo "dockutil is required. Install via: brew install dockutil" >&2
  exit 1
fi

trap 'killall Dock >/dev/null 2>&1 || true' EXIT

remove_labels=(
  Launchpad
  Safari
  Messages
  Mail
  Maps
  Photos
  FaceTime
  Calendar
  Contacts
  Reminders
  Notes
  Freeform
  TV
  Music
  Keynote
  Numbers
  Pages
  "App Store"
)

for label in "${remove_labels[@]}"; do
  dockutil --no-restart --remove "${label}" || true
done

echo "Dock cleaned. It will restart to apply changes."
