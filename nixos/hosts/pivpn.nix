{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];
  networking.hostName = "pivpn";
}
