{ pkgs, USERNAME, HOSTNAME, ... }:

{
  networking.hostName = HOSTNAME;

  system.primaryUser = USERNAME;

  nix.enable = false;

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

  system.stateVersion = 5;
}
