{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "polar-fox";
    firewall = {
      enable = false;
    };
  };

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    desktop = {
      enable = true;
      loginManager = true;
      loginManagerDefaultSession = true;
    };
    games = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
  };
}
