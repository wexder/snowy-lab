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
    desktop = {
      enable = true;
      desktop = "hyprland";
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = true;
    };
  };
}
