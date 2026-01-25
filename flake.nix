{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
  let
    USERNAME = "hirofumiomi";
    HOSTNAME = "hirofumiomi";
    system = "aarch64-darwin"; 
  in
  {
    darwinConfigurations.${HOSTNAME} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit USERNAME HOSTNAME; };
      modules = [
        ./darwin/configuration.nix
      ];
    };
  };
}
