{ config, lib, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

}
