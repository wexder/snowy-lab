{
  description = "Input into the snowy lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    zen-browser.url = "github:youwen5/zen-browser-flake?ref=a136a82830bc207f4387efbe9b718778db51600c";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland?tag=v0.53.1";
    hy3 = {
      url = "github:outfoxxed/hy3?tag=hl0.53.1";
      inputs.hyprland.follows = "hyprland";
    };
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # will be swapped for my own solution
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    {
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
      tuxedo-nixos,
      hyprland,
      hy3,
      quickshell,
      ...
    }@attrs:
    let
      inherit (nixpkgs.lib)
        mapAttrs
        nixosSystem
        ;

      inherit (flake-utils.lib) system;

      # catalog.nodes defines the systems available in this flake.
      catalog = import ./nixos/catalog.nix { inherit system; };
    in
    {
      darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nixos/hosts/air.nix
          ./nixos/home/air.nix
          home-manager.darwinModules.default
          agenix.darwinModules.default
          {
            environment.systemPackages = [ agenix.packages.aarch64-darwin.default ];
          }
        ];
        specialArgs = {
          inherit attrs;
          isLinux = false;
        };
      };

      # Convert nodes into a set of nixos configs.
      nixosConfigurations =
        let
          metalSystems = mapAttrs (
            host: node:
            let
              stablePkgs = import stable {
                inherit (node) system;
                overlays = [
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
                  ];
                };
              };
              specialArgs = attrs // {
                inherit catalog;
                hostName = host;
                stable = stablePkgs;
                zen-browser = zen-browser.packages.${node.system};
                hyprland-flake = hyprland.packages.${node.system};
                hyprland-plugins = [ hy3.packages.${node.system}.hy3 ];
                quickshell_pkg = quickshell.packages.${node.system}.default;
                isLinux = true;
              };
            in
            nixosSystem {
              inherit (node) system;
              specialArgs = specialArgs;
              modules = [
                tuxedo-nixos.nixosModules.default
                agenix.nixosModules.default
                disko.nixosModules.disko
                node.config
                node.hw
                home-manager.nixosModules.home-manager
                {
                  home-manager.useUserPackages = true;
                  home-manager.users.wexder = node.home;
                  home-manager.extraSpecialArgs = specialArgs;
                }
                {
                  environment.systemPackages = [ agenix.packages.${node.system}.default ];
                }
              ];
            }
          ) catalog.nodes;
        in
        metalSystems;
    };
}
