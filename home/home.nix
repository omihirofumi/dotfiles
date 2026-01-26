{ config, pkgs, USERNAME, ... }:
{
  home.username = USERNAME;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    zinit
    mise
    oh-my-posh

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
  ];

  imports = [
    ./zsh.nix
    ./git.nix
  ];

  home.file.".config/favdirs".source = ./favdirs;
  home.file.".config/negligible.omp.json".source = ./negligible.omp.json;
}
