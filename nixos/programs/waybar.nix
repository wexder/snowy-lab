{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./waybar/style.css);
  };
}
