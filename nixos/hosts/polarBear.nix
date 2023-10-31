{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking.hostName = "polar-bear";

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    xMinimalDesktop = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = true;
    };
  };
}
