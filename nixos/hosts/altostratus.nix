{ config, pkgs, lib, ... }:
{
  imports = [
    ../common.nix
  ];
  # networking.networkmanager.enable = false;
  networking = {
    hostName = "altostratus";
    nameservers = [ "1.1.1.1" "1.1.0.0" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53 ];
      allowedUDPPorts = [ 53 51820 ];
    };
  };

  environment.systemPackages = [
    # remove after fixed
    pkgs.bash
  ];

  roles = {
    tailscale = {
      enable = true;
      authkeyPath = config.age.secrets.tailscale.path;
    };
    netmaker = {
      client = {
        enable = true;
      };
      server = {
        enable = true;
      };
    };
  };
}
