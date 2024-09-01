{ config, lib, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

}
