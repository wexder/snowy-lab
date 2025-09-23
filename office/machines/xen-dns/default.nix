{ nixpkgs
, disko
, agenix
, deploy-rs
} @attrs:

let
  makeOs = ip:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs // {
        inherit ip;
      };
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        disko.nixosModules.disko
      ];
    };

  makeNode = ip:
    {
      sshUser = "root";
      hostname = ip;
      sshOpts = [ "-i" "~/.ssh/AI" ];
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos (makeOs ip);
      };
    };
in
{
  deploy = {
    xenDns1 = makeNode "192.168.240.193";
    xenDns2 = makeNode "192.168.240.177";
  };
  nixosConfigurations = {
    xenDns1 = makeOs "192.168.240.193";
    xenDns2 = makeOs "192.168.240.177";
  };
}
