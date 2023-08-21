{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
    ../programs/zsh.nix
    ../programs/git.nix
  ];
  networking.hostName = "snowy-deck";

  roles = {
    docker = {
      enable = true;
    };
  };
}
