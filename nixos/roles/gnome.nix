{ config, pkgs, lib, ... }:
let
  cfg = config.roles.gnome;
in
{
  options.roles.gnome = {
    enable = lib.mkEnableOption "Enable gnome";
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
    };
}
