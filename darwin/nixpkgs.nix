{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password-cli"
      "1password-gui"
      "1password"
      "google-chrome"
      "jetbrains-toolbox"
      "dbeaver-bin"
      "notion-app"
      "chatgpt"
      "alt-tab-macos"
      "ghostty"
      "karabiner-elements"
      "rancher"
      "raycast"
    ];
}
