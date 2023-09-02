{ config, pkgs, lib, ... }:
let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = {
    enable = lib.mkEnableOption "Enable desktop";
  };

  config = lib.mkIf cfg.enable
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      programs.xwayland.enable = true;

      xdg = {
        portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ];
          # DEPRECATED 
          # gtkUsePortal = true;
        };
      };

      fonts.packages = with pkgs; [
        nerdfonts
      ];

    };
}
