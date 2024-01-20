{ config, pkgs, ... }:

{
  imports = [
    ../programs/alacritty.nix
    ../programs/firefox.nix
    ../programs/git.nix
    ../programs/virtManager.nix
    ../programs/zsh.nix
    ./common.nix
  ];
}
