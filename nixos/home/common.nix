{ config, pkgs, ... }:

{
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = "wexder";
  home.homeDirectory = "/home/wexder";

  imports = [
    ../programs/nvim.nix
  ];
}
