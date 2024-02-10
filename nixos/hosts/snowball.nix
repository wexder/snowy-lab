{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "snowball";
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
    desktop = {
      enable = true;
    };
    tailscale = {
      enable = true;
      authkeyPath = config.age.secrets.tailscale.path;
    };
  };
}
