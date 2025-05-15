{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "snowflake";
  };

  # Needed for tmux
  environment.systemPackages = [
    pkgs.ghostty
  ];

  roles = {
    dev = {
      enable = true;
    };
    twingate = {
      enable = true;
    };
    mccDev = {
        enable = true;
    };
    officeWg = {
      enable = true;
      address = "192.168.250.5/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
  };
}
