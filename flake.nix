{
  description = "Simple NixOS Configuration";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors/main";
      flake = false;
    };
    starshipConfig = {
      url = "https://gist.githubusercontent.com/Ardenet/dfd994874c040890c28f854e3bdcd4db/raw/starship.toml";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-wsl,
    ...
  }: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = with inputs; {
          inherit starshipConfig;
          yaziFlavors = yazi-flavors;
        };
        modules = [
          nixos-wsl.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
