{ config, pkgs, ... }:

{
  imports = [
    ../programs/alacritty.nix
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/zsh.nix
    ./common.nix
  ];
}
