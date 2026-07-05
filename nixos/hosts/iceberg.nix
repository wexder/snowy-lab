{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "iceberg";
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
  };

  environment.systemPackages = [ ];

  users.users.wexder.password = "test";
  users.users.wexder.hashedPasswordFile = null;
  users.users.wexder.extraGroups = [
    "dialout"
    "bluetooth"
  ];

  hardware.flipperzero.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  roles = {
    laptop = {
      enable = true;
    };
    cad = {
      enable = false;
    };
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    twingate = {
      enable = false;
    };
    desktop = {
      enable = true;
      syncthing = true;
    };
    mccDev = {
      enable = true;
      use_netbird = true;
    };
    "3d" = {
      enable = false;
    };
    officeWg = {
      enable = true;
      address = "192.168.250.5/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
    virtualisation = {
      enable = false;
    };
    wine = {
      enable = false;
    };
    work = {
      enable = true;
    };
    flatpak = {
      enable = false;
    };
    zerotier = {
      enable = false;
    };
  };
}
