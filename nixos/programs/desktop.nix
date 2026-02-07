{
  config,
  lib,
  pkgs,
  quickshell,
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
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdeconnect-kde
      pkgs.dbeaver-bin
      pkgs.caprine-bin
      pkgs.bitwarden-desktop
      pkgs.vlc
      pkgs.kooha
      pkgs.tigervnc

      pkgs.dbus
      pkgs.kdePackages.kdeconnect-kde
      pkgs.dconf
      pkgs.wl-clipboard
      pkgs.wdisplays

      quickshell

      # maybe ?
      # pkgs.waypipe
    ];

    # services.blueman-applet.enable = true;

    services.cliphist.enable = true;
    home.file.".config/wallpapers".source = pkgs.fetchFromGitHub {
      owner = "wexder";
      repo = "snowy-lab-wallpapers";
      rev = "ac4ee28c9f72b322ee047a0a046273ef52c8b04e";
      hash = "sha256-kEuiRqPltWAlrPeTqOfd+hk8FTi1c90YvY6j5fA8cUY=";
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
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
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
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };
}
