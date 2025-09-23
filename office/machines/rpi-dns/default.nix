{ nixpkgs
, disko
, agenix
, deploy-rs
,
}@attrs:

let
  makeOs =
    ip:
    nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs // {
        inherit ip;
      };
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        disko.nixosModules.disko
      ];
    };

  makeNode = ip: {
    sshUser = "root";
    hostname = ip;
    sshOpts = [
      "-i"
      "~/.ssh/AI"
    ];
    profiles.system = {
      user = "root";
      path = deploy-rs.lib.aarch64-linux.activate.nixos (makeOs ip);
    };
  };
in
{
  deploy = {
    rpiDns1 = makeNode "192.168.240.49";
  };
  nixosConfigurations = {
    rpiDns1 = makeOs "192.168.240.49";
  };
}
