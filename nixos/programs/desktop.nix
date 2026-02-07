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

    home.file.".config/wallpapers".source = pkgs.fetchFromGitHub {
      owner = "wexder";
      repo = "snowy-lab-wallpapers";
      rev = "ac4ee28c9f72b322ee047a0a046273ef52c8b04e";
      hash = "sha256-kEuiRqPltWAlrPeTqOfd+hk8FTi1c90YvY6j5fA8cUY=";
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Quintom_Snow";
      size = 32;
      package = pkgs.quintom-cursor-theme;
    };

    gtk = {
      enable = true;
      cursorTheme = {
        name = "Quintom_Snow";
        package = pkgs.quintom-cursor-theme;
      };
      theme = {
        name = "Catppuccin-Macchiato-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "pink" ];
          size = "compact";
          tweaks = [
            "rimless"
            "black"
          ];
          variant = "macchiato";
        };
      };
    };

    # programs.dconf.profiles.user.databases = [
    #   {
    #     settings."org/gnome/desktop/interface" = {
    #       color-scheme = "prefer-dark";
    #       gtk-theme = "Catppuccin-Macchiato-Compact-Pink-Dark";
    #       # icon-theme = "Flat-Remix-Red-Dark";
    #       # font-name = "Noto Sans Medium 11";
    #       # document-font-name = "Noto Sans Medium 11";
    #       # monospace-font-name = "Noto Sans Mono Medium 11";
    #     };
    #   }
    # ];

    services.cliphist.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Catppuccin-Macchiato-Compact-Pink-Dark";
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };
}
