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
    desktop = lib.mkOption {
      default = "sway";
      example = "gnome";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security.rtkit.enable = true;

        programs.xwayland.enable = true;
        services.blueman.enable = true;
        programs.thunar.enable = true;

        fonts.packages = with pkgs; [
          nerdfonts
          fira-code-nerdfont
        ];

        environment.systemPackages = with pkgs;[
          wayvnc
          pavucontrol
          blueberry
          grim
          swappy
          slurp
          libreoffice
        ];
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };

        xdg = {
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${cfg.desktop}";
              user = "greeter";
            };
          };
        };
      }
    ]
  );
}
