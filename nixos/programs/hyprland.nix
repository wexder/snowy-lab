{
  config,
  lib,
  pkgs,
  hyprland-flake,
  hyprland-plugins,
  pyprland,
  ...
}:
let
  cfg = config.roles.desktop;

  # Hyprland is themed from the same palette as the shell, so the compositor's
  # borders and hy3's tab bar stay in step with the bar and its panels. Edit the
  # colours in roles.quickshell.colors, not here.
  palette = config.roles.quickshell.colors;

  # Hyprland parses "#RRGGBB" and "#RRGGBBAA"; the palette tokens are the
  # former, so an alpha is just two more hex digits on the end.
  fade = colour: alpha: "${colour}${alpha}";

  # Prepended to the lua config, which reads these as `theme.*`. Kept as a
  # generated prelude rather than literals in hyprland.lua so the palette has
  # exactly one definition.
  themePrelude = ''
    -- Generated from roles.quickshell.colors by nixos/programs/hyprland.nix.
    local theme = {
      active_border   = "${palette.primary}",
      active_border2  = "${palette.secondary}",
      inactive_border = "${palette.overlay}",
      nogroup_border  = "${palette.surfaceAlt}",
      shadow          = "${fade "#000000" "73"}",
      shadow_inactive = "${fade "#000000" "40"}",

      -- hy3 tab bar. It is rendered as a 5px indicator strip with no text, so
      -- these read as solid rows rather than tinted panels.
      tab_active      = "${palette.primary}",
      tab_focused     = "${palette.secondary}",
      tab_inactive    = "${fade palette.overlay "99"}",
      tab_urgent      = "${palette.error}",
      tab_locked      = "${palette.warning}",
      tab_alt_monitor = "${fade palette.muted "aa"}",
      tab_text        = "${palette.text}",
    }
  '';
in
{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./mako.nix
    ./wofi.nix
    ./waybar.nix
    ./kanshi.nix
    ./quickshell.nix
  ];

  config = lib.mkIf (cfg.kind == "hyprland") {
    home.file.".config/hypr/murder.sh" = {
      text = builtins.readFile ./hyprland/kill.sh;
      executable = true;
    };

    home.packages = [
      # Needed to close steam
      pkgs.xdotool
      pkgs.kanshi
      pkgs.mako
      pkgs.hyprlock
      pkgs.hypridle
      pyprland
    ];

    home.file = {
      ".config/pypr/config.toml".source = ./pyprland/pyprland.toml;
    };

    xdg.portal = {
      configPackages = [ hyprland-flake.hyprland ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = hyprland-flake.hyprland;
      portalPackage = hyprland-flake.xdg-desktop-portal-hyprland;
      plugins = hyprland-plugins;
      xwayland.enable = true;
      systemd.enable = true;
    };

    wayland.windowManager.hyprland.settings = { };

    wayland.windowManager.hyprland.extraConfig = themePrelude + builtins.readFile ./hyprland/hyprland.lua;
  };
}
