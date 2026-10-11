{
  config,
  lib,
  pkgs,
  stable,
  quickshell,
  panoply,
  ...
}:
let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = {
    enable = lib.mkEnableOption "Enable desktop";
    kind = lib.mkOption {
      type = lib.types.enum [
        "sway"
        "hyprland"
      ];
    };
    wallpaper = lib.mkOption {
      description = "File in ~/.config/wallpapers to show as the desktop background.";
      type = lib.types.str;
      default = "mountains-on-mars.png";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdeconnect-kde
      pkgs.dbeaver-bin
      pkgs.caprine-bin
      stable.bitwarden-desktop
      pkgs.vlc
      pkgs.kooha
      pkgs.tigervnc
      pkgs.tesseract

      pkgs.dbus
      pkgs.kdePackages.kdeconnect-kde
      pkgs.dconf
      pkgs.wl-clipboard
      pkgs.wdisplays

      panoply
      quickshell

      # maybe ?
      # pkgs.waypipe
    ];

    services.blueman-applet.enable = true;

    services.cliphist.enable = true;
    services.wl-clip-persist.enable = true;

    # home.file.".config/wallpapers".source = pkgs.fetchFromGitHub {
    #   owner = "wexder";
    #   repo = "snowy-lab-wallpapers";
    #   rev = "ac4ee28c9f72b322ee047a0a046273ef52c8b04e";
    #   hash = "sha256-kEuiRqPltWAlrPeTqOfd+hk8FTi1c90YvY6j5fA8cUY=";
    # };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [ ];
    };

    # home.pointerCursor = {
    #   gtk.enable = true;
    #   x11.enable = true;
    #   name = "Quintom_Snow";
    #   size = 32;
    #   package = pkgs.quintom-cursor-theme;
    # };

    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };
      cursorTheme = {
        name = "Catppuccin-Mocha-Light-Cursors";
        package = pkgs.catppuccin-cursors.mochaLight;
      };
      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
      };
      gtk4 = {
        theme = null;
        # libadwaita apps follow the portal's colour scheme, but plain GTK4
        # apps only go dark with this set.
        extraConfig.gtk-application-prefer-dark-theme = true;
      };
    };
    qt = {
      enable = true;
      platformTheme = {
        name = "gtk3";
      };
      style = {
        name = "gtk2";
        package = pkgs.kdePackages.breeze-gtk;
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      name = "Catppuccin-Mocha-Light-Cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 16;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Breeze-Dark";
        color-scheme = "prefer-dark";
      };
      # Route blueman through the notification daemon rather than its own GTK
      # fallback dialog. This was off because mako expired pairing
      # confirmations after 5s and did not render their actions; quickshell
      # draws the action buttons and keeps actionable notifications up until
      # they are answered (behaviour.persistActionable).
      "org/blueman/general" = {
        notification-daemon = true;
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };
}
