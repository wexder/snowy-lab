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
      desktop = "gnome";
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = true;
    };
    gnome = {
      enable = true;
    };
  };
}
