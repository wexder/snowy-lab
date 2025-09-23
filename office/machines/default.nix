{ nixpkgs
, disko
, agenix
, deploy-rs
,
}:
let
  xenDns = import ./xen-dns {
    inherit
      nixpkgs
      disko
      agenix
      deploy-rs
      ;
  };
  # rpiDns = import ./rpi-dns {
  #   inherit nixpkgs disko agenix deploy-rs;
  # };
  rpiDns = {
    deploy = { };
    nixosConfigurations = { };
  };
in
{
  deploy = { } // xenDns.deploy // rpiDns.deploy;
  nixosConfigurations = { } // xenDns.nixosConfigurations // rpiDns.nixosConfigurations;
}
