{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    tidal-hifi
    playerctl
  ];
}
