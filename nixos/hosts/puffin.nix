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
    hostName = "puffin";
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

  environment.systemPackages = [
  ];

  users.users.wexder.password = "test";
  users.users.wexder.hashedPasswordFile = null;
  users.users.wexder.extraGroups = [
    "dialout"
    "bluetooth"
  ];

  hardware.flipperzero.enable = true;

  roles = {
    laptop = {
      enable = true;
    };
    dev = {
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
    officeWg = {
      enable = true;
      address = "192.168.250.8/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
    virtualisation = {
      enable = true;
    };
    work = {
      enable = true;
    };
  };
}
