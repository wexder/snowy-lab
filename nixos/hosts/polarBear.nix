{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "polar-bear";
    firewall = {
      enable = false;
    };

    wireless.iwd.enable = true;
    wireless.iwd.settings =
      {
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        Settings = {
          AutoConnect = true;
        };
      };
  };

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    lsp = {
      go = true;
      rust = true;
      zig = true;
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
    prometheus = {
      enable = true;
      nut = true;
    };
    virtualisation = {
      enable = true;
    };
  };
}
