{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "walrus";
    firewall = {
      enable = true;
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
  ];
  users.users.wexder.password = "test";
  users.users.wexder.hashedPasswordFile = null;

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    netbird = {
      enable = false;
    };
    twingate = {
      enable = true;
    };
    desktop = {
      enable = true;
      syncthing = true;
    };
    tailscale = {
      enable = false;
      authkeyPath = config.age.secrets.tailscale.path;
    };
    officeWg = {
      enable = true;
      address = "192.168.250.5/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
  };
}
