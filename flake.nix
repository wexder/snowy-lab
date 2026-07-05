{
  description = "Input into the snowy lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:LuckShiba/nixpkgs/tuxedo-fix";
    stable.url = "github:NixOS/nixpkgs/24.05";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    helium.url = "github:vikingnope/helium-browser-nix-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    watt.url = "github:notashelf/watt";
    watt.inputs.nixpkgs.follows = "nixpkgs";

    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos/v2.1.20";
    # tuxedo-nixos.inputs.nixpkgs.follows = "nixpkgs";

    intel-lpmd.url = "github:dmfrpro/intel-lpmd-flake";
    intel-lpmd.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # will be swapped for my own solution
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    self,
    nix-darwin,
    deploy-rs,
    nixpkgs,
    agenix,
    flake-utils,
    disko,
    home-manager,
    nixos-generators,
    stable,
    zen-browser,
    helium,
    watt,
    tuxedo-nixos,
    intel-lpmd,
    ...
  } @ attrs: let
    inherit
      (nixpkgs.lib)
      mapAttrs
      nixosSystem
      ;

    inherit (flake-utils.lib) system;

    # catalog.nodes defines the systems available in this flake.
    catalog = import ./nixos/catalog.nix {inherit system;};
  in {
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [
        ./nixos/hosts/air.nix
        ./nixos/home/air.nix
        home-manager.darwinModules.default
        agenix.darwinModules.default
        {
          environment.systemPackages = [agenix.packages.aarch64-darwin.default];
        }
      ];
      specialArgs = {
        inherit attrs;
        isLinux = false;
      };
    };

    # Convert nodes into a set of nixos configs.
    nixosConfigurations = let
      metalSystems =
        mapAttrs (
          host: node: let
            stablePkgs = import stable {
              inherit (node) system;
              overlays = [
                watt.outputs.overlays.watt
                (final: prev: {
                  clockify = prev.clockify.overrideAttrs (old: {
                    src = prev.fetchurl {
                      url = "https://web.archive.org/web/20250419021523/https://clockify.me/downloads/Clockify_Setup.AppImage";
                      hash = "sha256-cQP1QkF2uWGsCjYjVdxPFLL8atAjT6rPQbPqeNX0QqQ=";
                    };
                  });
                })
              ];
              config = {
                allowUnfree = true;
                allowBroken = true;
                permittedInsecurePackages = [
                  "electron-25.9.0"
                  "electron-39.8.10"
                ];
              };
            };
          in
            nixosSystem {
              inherit (node) system;
              specialArgs =
                attrs
                // {
                  inherit catalog;
                  hostName = host;
                  stable = stablePkgs;
                  zen-browser = zen-browser.packages.${node.system};
                  helium-browser = helium.packages.${node.system};
                  isLinux = true;
                };
              modules = [
                watt.nixosModules.default
                tuxedo-nixos.nixosModules.default
                agenix.nixosModules.default
                disko.nixosModules.disko
                node.config
                node.hw
                home-manager.nixosModules.home-manager
                intel-lpmd.nixosModules.default
                {
                  home-manager.useUserPackages = true;
                  home-manager.users.wexder = import node.home;
                }
                {
                  environment.systemPackages = [agenix.packages.${node.system}.default];
                }
              ];
            }
        )
        catalog.nodes;
    in
      metalSystems;
  };
}
