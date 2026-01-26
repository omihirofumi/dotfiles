{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    USERNAME = "hirofumiomi";
    HOSTNAME = "hirofumiomi";
    system = "aarch64-darwin";
  in
  {
    darwinConfigurations.${HOSTNAME} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs USERNAME HOSTNAME; };

      modules = [
        ./darwin/configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit USERNAME;
          };

          home-manager.users.${USERNAME} = import ./home/home.nix;
        }
      ];
    };
  };
}
