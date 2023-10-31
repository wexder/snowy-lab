{ config, pkgs, ... }:

{
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
  home.username = "wexder";
  home.homeDirectory = "/home/wexder";

  imports = [
    ../programs/nvim.nix
    ../extensions/tigervnc.nix
  ];
}
