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

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = [
          pkgs.slack
          pkgs.wayvnc
          pkgs.pavucontrol
          pkgs.blueberry
          pkgs.grim
          pkgs.swappy
          pkgs.slurp
          pkgs.libreoffice

          pkgs.ledger-live-desktop # testing
          pkgs.yubioath-flutter # testing
          pkgs.pcsclite # testing
        ];

        services.udev.packages = [ pkgs.yubikey-personalization ]; # testing
        services.pcscd.enable = true; # testing

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          # jack.enable = true;
        };
        services.dbus.enable = true;

        xdg.portal = {
          enable = true;
          wlr.enable = true;
          wlr.settings = {
            screencast = {
              chooser_type = "simple";
              # works but doesn not allow choosing windows
              chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
            };
          };
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
          configPackages = [ pkgs.sway ];
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

        systemd.user.services.polkit-kde-authentication-agent-1 = {
          description = "polkit-kde-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      }
    ]
  );
}
