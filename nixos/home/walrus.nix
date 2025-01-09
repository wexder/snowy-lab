{ config, pkgs, ... }:

{
  imports = [
    ../programs/ghostty.nix
    ../programs/alacritty.nix
    ../programs/firefox.nix
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/zsh.nix
    ./common.nix
  ];
}
