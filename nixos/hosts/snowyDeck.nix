{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];
  networking.hostName = "snowy-deck";

  roles = {
    docker = {
      enable = true;
    };
  };
}
