{ config, pkgs, ... }:

{
  imports = [
    ../programs/ghostty.nix
    ../programs/alacritty.nix
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/virtManager.nix
    ../programs/zsh.nix
    ./common.nix
  ];
}
