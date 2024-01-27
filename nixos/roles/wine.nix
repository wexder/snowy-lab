{ config, pkgs, lib, ... }:
let
  cfg = config.roles.wine;
in
{
  options.roles.wine = {
    enable = lib.mkEnableOption "Wine";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = [
        pkgs.wine
        pkgs.wineWowPackages.staging
        pkgs.winetricks
        pkgs.wineWowPackages.waylandFull
        pkgs.vkd3d
        pkgs.vkdt-wayland
        pkgs.dxvk
        pkgs.q4wine # testing
        pkgs.bottles # testing
      ];
    };
}
