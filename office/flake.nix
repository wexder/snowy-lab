{
  description = "Deployment for my server cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    # For accessing `deploy-rs`'s utility Nix functions
    deploy-rs.url = "github:serokell/deploy-rs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, deploy-rs, disko, agenix }:
    let
      nodes = import ./machines {
        inherit nixpkgs disko agenix deploy-rs;
      };
    in
    {
      deploy.nodes = nodes.deploy;

      nixosConfigurations = nodes.nixosConfigurations;

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
