#!/bin/sh

set -e # exit on error

if [ ! "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! "$(command -v chezmoi)" ]; then
  brew install chezmoi
fi

chezmoi init --apply omihirofumi
