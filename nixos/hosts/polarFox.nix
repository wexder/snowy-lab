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
      android = true;
    };
    desktop = {
      enable = true;
      loginManager = true;
    };
    games = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
    videoEditing = {
      enable = true;
    };
  };
}
