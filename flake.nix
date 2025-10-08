{
  description = "Simple NixOS Configuration";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?shallow=1&ref=nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yaziFlavors = {
      url = "github:yazi-rs/flavors/main";
      flake = false;
    };
    starshipConfig = {
      url = "https://gist.githubusercontent.com/Ardenet/dfd994874c040890c28f854e3bdcd4db/raw/starship.toml";
      flake = false;
    };
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = with inputs; {
          inherit inputs;
        };
        modules = [
          ./machines/wsl.nix

          # External Software's modules import and configurations
          ./external/nixos-wsl.nix
        ];
      };
      Centaurus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./machines/xiaoxin-pro14

          # External Software's modules import and configurations
          ./external/noctalia.nix
        ];
      };
      vmware = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./machines/vmware

          # External Software's modules import and configurations
          ./external/noctalia.nix
        ];
      };
    };
  };
}
