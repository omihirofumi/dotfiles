{ pkgs, USERNAME, HOSTNAME, ... }:

{
  networking.hostName = HOSTNAME;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;

      # キーリピート
      KeyRepeat = 2;
      InitialKeyRepeat = 15;

      # トラックパッド速度
      "com.apple.trackpad.scaling" = 3.0;

      # 長押しアクセント無効
      ApplePressAndHoldEnabled = false;
    };
  };

  system.stateVersion = 5;
}
