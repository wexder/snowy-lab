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

    wireless.enable = true;
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
  };
}
