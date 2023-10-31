{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../programs/zsh.nix
    ../programs/git.nix
    ../programs/firefox.nix
    ../programs/alacritty.nix
  ];
}
