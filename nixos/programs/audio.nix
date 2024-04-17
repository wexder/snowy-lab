{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    tidal-hifi
    playerctl
  ];

  services.mpris-proxy.enable = true;
  # services.mpd-mpris.enable = true;
}
