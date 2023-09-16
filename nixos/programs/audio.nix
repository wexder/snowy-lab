{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    tidal-hifi
    playerctl
  ];

  services.mpris-proxy = {
    enabled = true;
  };
}
