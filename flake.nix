{
  description = "Input into the snowy lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/24.05";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:wexder/nixos-hardware/feature/t4-gen4";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, flake-utils, disko, home-manager, nixos-generators, stable, zen-browser, ... }@attrs:
    let
      inherit (nixpkgs.lib)
        mapAttrs mapAttrs' nixosSystem;

      inherit (flake-utils.lib) eachSystemMap system;

      # catalog.nodes defines the systems available in this flake.
      catalog = import ./nixos/catalog.nix { inherit system; };
    in
    rec {
      # Convert nodes into a set of nixos configs.
      nixosConfigurations =
        let
          # Bare metal systems.
          metalSystems = mapAttrs
            (host: node:
              let
                stablePkgs = import stable {
                  inherit (node) system;
                  overlays = [ ];
                  config = {
                    allowUnfree = true;
                    allowBroken = true;
                    permittedInsecurePackages = [
                      "electron-25.9.0"
                    ];
                  };
                };
              in
              nixosSystem {
                inherit (node) system;
                specialArgs = attrs // {
                  inherit catalog;
                  hostName = host;
                  stable = stablePkgs;
                  zen-browser = zen-browser.packages.${node.system};
                };
                modules = [
                  agenix.nixosModules.default
                  disko.nixosModules.disko
                  node.config
                  node.hw
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.wexder = import node.home;
                  }
                  {
                    environment.systemPackages = [ agenix.packages.${node.system}.default ];
                  }
                ];
              })
            catalog.nodes;
        in
        metalSystems;
    };
}
