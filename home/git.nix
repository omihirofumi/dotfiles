{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "omihirofumi";
    userEmail = "99390907+omihirofumi@users.noreply.github.com";

    extraConfig = {
      core = {
        excludesFile = "${config.home.homeDirectory}/.config/git/ignore";
        pager = "delta";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        navigate = true;
        dark = true;
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      rebase = {
        autosquash = true;
      };
    };
  };

  xdg.configFile."git/ignore".source = ./git/ignore;
}
