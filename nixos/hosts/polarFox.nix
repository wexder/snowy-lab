{
  config,
  lib,
  pkgs,
  ...
}:
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
    wireless.iwd.settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      Settings = {
        AutoConnect = true;
      };
    };
    networkmanager.wifi.backend = "iwd";
  };

  environment.systemPackages = [
    # pkgs.lychee-slicer # testing
    pkgs.platformio # testing
    pkgs.python3 # testing
  ];

  roles = {
    "3d" = {
      enable = false;
    };
    cad = {
      enable = false;
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
      syncthing = true;
    };
    games = {
      enable = true;
    };
    mccDev = {
      enable = true;
      use_netbird = false;
    };
    twingate = {
      enable = false;
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
    officeWg = {
      enable = true;
      address = "192.168.250.2/32";
      privateKeyFile = config.age.secrets.polarFoxCgWgPk.path;
    };
    work = {
      enable = true;
    };
    wireshark = {
      enable = true;
    };
    zerotier = {
      enable = true;
    };
  };
}
