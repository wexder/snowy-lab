{ config, lib, pkgs, ... }:
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

  environment.systemPackages = [
    pkgs.lychee-slicer
    pkgs.platformio # testing
    pkgs.python3 # testing
  ];

  roles = {
    "3d" = {
      enable = true;
    };
    cad = {
      enable = true;
    };
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
    virtualisation = {
      enable = true;
    };
    wine = {
      enable = true;
    };
  };
}
