{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];
  networking.hostName = "snowy-deck";

  roles = {
    docker = {
      enable = true;
    };
  };

  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        imports = [
          ./zsh.nix
          ./git.nix
        ];
      };
    };
  };
}
