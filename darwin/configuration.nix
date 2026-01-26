{ pkgs, USERNAME, HOSTNAME, ... }:

{

  system.primaryUser = USERNAME;

  nix.enable = false;

  users.users.${USERNAME} = {
    home = "/Users/${USERNAME}";
    shell = pkgs.zsh;
  }
;
  # macOS defaults
  system.defaults = {
    dock.autohide = true;
    dock.show-recents = false;
    dock.mru-spaces = false;

    finder.AppleShowAllExtensions = true;
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    finder.FXPreferredViewStyle = "Nlsv";

    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      "com.apple.trackpad.scaling" = 3.0;
      AppleShowAllExtensions = true;
    };
  };

  home-manager.backupFileExtension = "bak";

  system.stateVersion = 5;
}
