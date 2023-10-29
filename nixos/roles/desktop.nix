{ config, pkgs, lib, ... }:
let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    loginManager = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
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
        services.blueman.enable = true;

        xdg = {
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };

        fonts.packages = with pkgs; [
          nerdfonts
        ];

        environment.systemPackages = with pkgs;[
          wayvnc
        ];
      }

      (lib.mkIf cfg.loginManager {
        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
              user = "greeter";
            };
          };
        };
      })
    ]
  );
}
