{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "snowplow";
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
    pkgs.brightnessctl
    pkgs.bruno
    pkgs.element-desktop
  ];

  services.thinkfan = {
    enable = true;
    smartSupport = true;
    levels = [
      [ 0 0 55 ]
      [ 1 53 57 ]
      [ 2 55 61 ]
      [ 3 60 66 ]
      [ 4 63 67 ]
      [ 5 65 71 ]
      [ 6 70 76 ]
      [ 7 75 85 ]
      [ "level auto" 80 32767 ]
    ];
  };

  hardware.flipperzero.enable = true;

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    desktop = {
      enable = true;
      syncthing = true;
    };
    tailscale = {
      enable = true;
      # authkeyPath = config.age.secrets.tailscale.path;
    };
  };
}
