{
  config,
  pkgs,
  stable,
  zen-browser,
  hyprland,
  lib,
  ...
}:
let
  cfg = config.roles.desktop;
  hyprlandPkgs = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      default = "start-hyprland";
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
        security.pam.services.swaylock = { };
        security.pam.services.hyprlock = { };

        programs.xwayland.enable = true;

        # Hyprland comes from its own flake, built against that flake's nixpkgs.
        # The system graphics drivers have to come from the same nixpkgs: a mesa
        # built against a newer glibc cannot be loaded into Hyprland, which then
        # dies at startup with "Cannot open backend: no allocator available".
        hardware.graphics = lib.mkIf (cfg.desktop == "start-hyprland") {
          package = hyprlandPkgs.mesa;
          package32 = hyprlandPkgs.pkgsi686Linux.mesa;
        };
        # services.blueman.enable = true;
        programs.thunar = {
          enable = true;
          plugins = [
            pkgs.thunar-archive-plugin
            pkgs.thunar-volman
          ];
        };

        fonts.packages = [
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
          pkgs.karere
          pkgs.wayvnc
          pkgs.pavucontrol
          pkgs.blueman
          pkgs.grim
          pkgs.swappy
          pkgs.slurp
          pkgs.onlyoffice-desktopeditors
          stable.wallutils

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
          nssmdns4 = true;
          nssmdns6 = true;
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
        }; # testing
        hardware.sane.enable = true; # enables support for SANE scanners
        users.extraGroups.scanner.members = [ "wexder" ];
        users.extraGroups.lp.members = [ "wexder" ];

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
          # jack.enable = true;

          # BlueZ 5.87 refuses Acquire (NotAuthorized) on the aptX transport
          # when a phone/tablet streams to us, so drop the vendor codecs and
          # force AAC/SBC.
          wireplumber.configPackages = [
            (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-bluez-codecs.conf" ''
              monitor.bluez.properties = {
                bluez5.codecs = [ sbc sbc_xq aac ]
                bluez5.enable-sbc-xq = true
              }
            '')
          ];
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

        environment.pathsToLink = [
          "/share/applications"
          "/share/xdg-desktop-portal"
        ];

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${cfg.desktop}";
              user = "greeter";
            };
          };
        };

        systemd = {
          user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
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
                devices = [ "polar-bear" ];
              };
              "documents" = {
                id = "documents";
                path = "/home/wexder/documents/";
                devices = [ "polar-bear" ];
              };
              "obsidian" = {
                id = "obsidian";
                path = "/home/wexder/obsidian/";
                devices = [ "polar-bear" ];
              };
              "dbeaver" = {
                id = "dbeaver";
                path = "/home/wexder/.local/share/DBeaverData/workspace6";
                devices = [ "polar-bear" ];
              };
            };
            devices = {
              polar-bear = {
                id = "DTSBGY4-AHFZVTH-MKZOZSP-5XQGZ2Y-LHEE6QL-NWMI44M-5R2KBF4-SDPZPQ6";
              };
            };
          };
        };
      })
    ]
  );
}
