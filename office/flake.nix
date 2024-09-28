{
  description = "Deployment for my server cluster";
  inputs.nixpkgs_latest.url = "github:NixOS/nixpkgs/master";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  # For accessing `deploy-rs`'s utility Nix functions
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, deploy-rs, disko, nixpkgs_latest } @attrs: {
    nixosConfigurations.vpn = nixpkgs_latest.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs // {
        latestPkgs = nixpkgs_latest.legacyPackages."x86_64-linux";
      };
      modules = [
        ./vpn/configuration.nix
        disko.nixosModules.disko
      ];
    };

    deploy.nodes.vpn1 = {
      sshUser = "root";
      hostname = "192.168.240.193";
      sshOpts = [ "-i" "~/.ssh/AI" ];
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vpn;
      };
    };
    deploy.nodes.vpn2 = {
      sshUser = "root";
      hostname = "192.168.240.178";
      sshOpts = [ "-i" "~/.ssh/AI" ];
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vpn;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
