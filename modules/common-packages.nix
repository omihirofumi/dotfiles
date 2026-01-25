{ pkgs, ... }:
with pkgs; [
  # shell core
  zsh
  fzf
  zinit
  mise
  oh-my-posh
  thefuck

  # cli
  git
  gh
  lazygit
  bat
  eza
  ripgrep
  fd
  jq
  ghq
  helix
  jujutsu
]
