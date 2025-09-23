{ lib, pkgs, ... }:
let
  toZoneRow = subdomain: type: ip: "${subdomain} IN ${type} ${ip}";
  hostnames = (import ./hostnames.nix { }).dns;
  getIp = value: if builtins.isString value then value else value.ip;
  toARows = records: builtins.concatStringsSep "\n" (
    builtins.attrValues (
      builtins.mapAttrs (hostname: ip: toZoneRow hostname "A" (getIp ip)) records
    )
  );
  officeZone = pkgs.replaceVars ./zones/office.local-k8s.tech {
    records = toARows hostnames.office;
  };
  officeVpnZone = pkgs.replaceVars ./zones/office.vpn {
    records = toARows hostnames.vpn;
  };
in {
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

  services.coredns = {
    enable = true;
    config = ''
      . {
          file ${officeZone} office.local-k8s.tech
          file ${officeVpnZone} office.vpn

          bind 0.0.0.0
          forward . 8.8.8.8
          log
          errors
      }
    '';
  };
}
