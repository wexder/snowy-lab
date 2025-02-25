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

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";

    # testing
    # openziti.url = "github:johnalotoski/openziti-bins";
    openziti.url = "github:wexder/openziti-bins/init";
    # openziti.url = "git+file:///home/wexder/development/openziti-bins";
    openziti.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, flake-utils, disko, home-manager, nixos-generators, zig, zls, openziti, stable, zen-browser, ... }@attrs:
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
                  zig = zig.packages.${node.system};
                  zls = zls.packages.${node.system};
                  openziti = openziti.packages.${node.system};
                  stable = stablePkgs;
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
                    environment.systemPackages = [ agenix.packages.${node.system}.default zen-browser.packages.${node.system}.default ];
                  }
                ];
              })
            catalog.nodes;
        in
        metalSystems;

      # Generate an SD card image for each host.
      images = mapAttrs
        (host: node: nixosConfigurations.${host}.config.system.build.sdImage)
        catalog.nodes;

      packages = {
        x86_64-linux = {
          hello = nixpkgs.legacyPackages.x86_64-linux.hello;
        };
      };
      # packages =
      #   let
      #     # Converts node entry into a virtual machine package.
      #     vmPackage = sys: host: node: {
      #       name = host;
      #       value = {
      #         linode = nixos-generators.nixosGenerate {
      #           format = "linode";
      #           inherit (node) system;
      #           specialArgs = attrs // {
      #             inherit catalog;
      #             hostName = host;
      #           };
      #           modules = [
      #             disko.nixosModules.disko
      #             node.config
      #             # home-manager.nixosModules.home-manager
      #             # {
      #             #   home-manager.useGlobalPkgs = true;
      #             #   home-manager.useUserPackages = true;
      #             #   home-manager.users.wexder = import node.home;
      #             # }
      #             agenix.nixosModules.default
      #             ./nixos/hw/linode.nix
      #           ];
      #         };
      #
      #         qemu = nixos-generators.nixosGenerate {
      #           format = "vm";
      #           inherit (node) system;
      #           specialArgs = attrs // {
      #             inherit catalog;
      #             hostName = host;
      #           };
      #           modules = [
      #             disko.nixosModules.disko
      #             node.config
      #             # home-manager.nixosModules.home-manager
      #             # {
      #             #   home-manager.useGlobalPkgs = true;
      #             #   home-manager.useUserPackages = true;
      #             #   home-manager.users.wexder = import node.home;
      #             # }
      #             agenix.nixosModules.default
      #             ./nixos/hw/qemu.nix
      #           ];
      #         };
      #       };
      #     };
      #   in
      #   eachSystemMap [ system.x86_64-linux ]
      #     (sys: mapAttrs' (vmPackage sys) catalog.nodes);
    };
}
