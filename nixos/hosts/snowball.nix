{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking.hostName = "snowball";

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
  };
}
