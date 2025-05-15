{
  lib,
  pkgs,
  ...
}: let
  officeZone = lib.fileset.toSource {
    root = ./.;
    fileset = ./zones/office.local-k8s.tech;
  };
  officeVpnZone = lib.fileset.toSource {
    root = ./.;
    fileset = ./zones/office.vpn;
  };
in {
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

  services.coredns = {
    enable = true;
    config = ''
      . {
          file ${officeZone}/zones/office.local-k8s.tech office.local-k8s.tech
          file ${officeVpnZone}/zones/office.vpn office.vpn

          bind 0.0.0.0
          forward . 8.8.8.8
          log
          errors
      }
    '';
  };
}
