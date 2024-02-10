{
  description = "Input into the snowy lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # temporary
    nyoom.url = "github:ryanccn/nyoom";
    nyoom.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, agenix, flake-utils, home-manager, nixos-generators, nyoom, ... }@attrs:
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
              nixosSystem {
                inherit (node) system;
                specialArgs = attrs // {
                  inherit catalog;
                  hostName = host;
                };
                modules = [
                  node.config
                  node.hw
                  home-manager.nixosModules.home-manager
                  {
                    environment.systemPackages = [ nyoom.packages.${node.system}.default ];
                  }
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.wexder = import node.home;
                  }
                  agenix.nixosModules.default
                  {
                    environment.systemPackages = [ agenix.packages.${node.system}.default ];
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

      packages =
        let
          # Converts node entry into a virtual machine package.
          vmPackage = sys: host: node: {
            name = host;
            value = {
              linode = nixos-generators.nixosGenerate {
                format = "linode";
                inherit (node) system;
                specialArgs = attrs // {
                  inherit catalog;
                  hostName = host;
                };
                modules = [
                  node.config
                  # home-manager.nixosModules.home-manager
                  # {
                  #   home-manager.useGlobalPkgs = true;
                  #   home-manager.useUserPackages = true;
                  #   home-manager.users.wexder = import node.home;
                  # }
                  agenix.nixosModules.default
                  ./nixos/hw/linode.nix
                ];
              };

              qemu = nixos-generators.nixosGenerate {
                format = "vm";
                inherit (node) system;
                specialArgs = attrs // {
                  inherit catalog;
                  hostName = host;
                };
                modules = [
                  node.config
                  # home-manager.nixosModules.home-manager
                  # {
                  #   home-manager.useGlobalPkgs = true;
                  #   home-manager.useUserPackages = true;
                  #   home-manager.users.wexder = import node.home;
                  # }
                  agenix.nixosModules.default
                  ./nixos/hw/qemu.nix
                ];
              };
            };
          };
        in
        eachSystemMap [ system.x86_64-linux ]
          (sys: mapAttrs' (vmPackage sys) catalog.nodes);
    };
}
