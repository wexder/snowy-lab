{
  config,
  pkgs,
  stable,
  zen-browser,
  lib,
  ...
}: let
  cfg = config.roles.desktop;
in {
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
    syncthing = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security.rtkit.enable = true;
        security.pam.services.swaylock = {};

        programs.xwayland.enable = true;
        services.blueman.enable = true;
        programs.thunar.enable = true;

        fonts.packages =
          [
          ]
          ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

        networking.firewall.allowedTCPPortRanges = [
          # kdeconnect
          {
            from = 1714;
            to = 1716;
          }
        ];
        networking.firewall.allowedUDPPortRanges = [
          # kdeconnect
          {
            from = 1714;
            to = 1716;
          }
        ];

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = [
          pkgs.whatsapp-for-linux
          pkgs.wayvnc
          pkgs.pavucontrol
          pkgs.blueberry
          pkgs.grim
          pkgs.swappy
          pkgs.slurp
          pkgs.onlyoffice-desktopeditors
          pkgs.wallutils

          zen-browser.default
          stable.chromium
          pkgs.thunderbird

          pkgs.obsidian

          pkgs.discord
          pkgs.ghostty
          pkgs.signal-desktop

          pkgs.yubioath-flutter # testing
          pkgs.pcsclite # testing
          pkgs.pulseaudio # testing
          pkgs.alsa-utils # testing

          pkgs.simple-scan # testing
        ];

        security.pam.loginLimits = [
          {
            domain = "@users";
            item = "rtprio";
            type = "-";
            value = 1;
          }
        ];

        services.udev.packages = [
          pkgs.yubikey-personalization
          pkgs.opensc
          pkgs.yubico-piv-tool
          pkgs.pcsclite
          pkgs.pcsc-tools
          pkgs.opensc
          pkgs.gnupg
          pkgs.gnupg-pkcs11-scd
        ];
        hardware.gpgSmartcards.enable = true;
        programs.gnupg.agent.enable = true;
        services.pcscd.enable = true; # testing

        services.avahi = {
          nssmdns = true;
          enable = true;
          ipv4 = true;
          ipv6 = false;
          publish = {
            enable = true;
            addresses = true;
            workstation = true;
          };
        };
        services.printing = {
          enable = true;
          drivers = [
            pkgs.gutenprint
            # pkgs.hplip
          ];
        }; #testing
        hardware.sane.enable = true; # enables support for SANE scanners
        users.extraGroups.scanner.members = ["wexder"];
        users.extraGroups.lp.members = ["wexder"];

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
          # jack.enable = true;
        };
        # testing network party audio
        # environment.etc = {
        #   "pipewire/pipewire-pulse.conf.d/50-network-party.conf".text = ''
        #     context.exec = [
        #         { path = "pactl" args = "load-module module-native-protocol-tcp" }
        #         { path = "pactl" args = "load-module module-zeroconf-discover" }
        #         { path = "pactl" args = "load-module module-zeroconf-publish" }
        #     ]
        #   '';
        # };
        # # airplay
        # environment.etc = {
        #   "pipewire/pipewire.conf.d/raop-discover.conf".text = ''
        #     context.modules = [
        #        {
        #            name = libpipewire-module-raop-discover
        #            args = { }
        #        }
        #     ]
        #   '';
        # };
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
          configPackages = [pkgs.sway];
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

        systemd = {
          user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = ["graphical-session.target"];
            wants = ["graphical-session.target"];
            after = ["graphical-session.target"];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              Restart = "on-failure";
              RestartSec = 1;
              TimeoutStopSec = 10;
            };
          };
        };
      }

      (lib.mkIf cfg.syncthing {
        services.syncthing = {
          enable = true;
          user = "wexder";
          dataDir = "/home/wexder/.config/syncthing";
          settings = {
            folders = {
              "thunderbird" = {
                id = "thunderbird";
                path = "/home/wexder/.thunderbird/";
                devices = ["polar-bear"];
              };
              "documents" = {
                id = "documents";
                path = "/home/wexder/documents/";
                devices = ["polar-bear"];
              };
              "obsidian" = {
                id = "obsidian";
                path = "/home/wexder/obsidian/";
                devices = ["polar-bear"];
              };
            };
            devices = {
              polar-bear = {
                id = "WYQIGNT-BE6FGPD-EW4X2WP-N7VQUV4-ASLKO3W-YZ2QW6H-IQUPC4E-7WW3NQ7";
              };
            };
          };
        };
      })
    ]
  );
}
