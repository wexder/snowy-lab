{
  config,
  pkgs,
  ...
}: let
  proxmark3 = pkgs.proxmark3.override {
    withGeneric = true;
  };
in {
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "walrus";
    firewall = {
      enable = true;
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

  environment.systemPackages = [
    proxmark3
    pkgs.intel-undervolt
  ];

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
      enable = true;
    };
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    twingate = {
      enable = true;
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
      enable = true;
    };
    officeWg = {
      enable = true;
      address = "192.168.250.5/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
    virtualisation = {
      enable = true;
    };
    wine = {
      enable = true;
    };
    work = {
      enable = true;
    };
    flatpak = {
      enable = true;
    };
  };
}
