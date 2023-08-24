{ config, pkgs, ... }:

{
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "wexder";
  home.homeDirectory = "/home/wexder";
}
