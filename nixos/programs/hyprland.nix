{
  config,
  lib,
  pkgs,
  osConfig,
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

  # hyprlock wants "rgb(RRGGBB)" where the palette has "#RRGGBB".
  hyprlockColour = colour: "rgb(${lib.removePrefix "#" colour})";

  lockFont = config.roles.quickshell.font.family;
  # hyprlock cannot read SVG, so the logo is rasterised at build time, well
  # above its on-screen size so it stays sharp on a scaled display.
  lockLogo = pkgs.runCommand "lock-logo.png" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
    rsvg-convert --height 360 ${./hyprland/lock-logo.svg} -o $out
  '';

  isLaptop = osConfig.roles.laptop.enable or false;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  # The Lua config mode rejects the classic `dispatch dpms on` spelling.
  # The keyboard backlight goes dark with the screen. `-s` saves the level and
  # `-r` restores it; laptops without one just fail the command harmlessly.
  kbdBacklight = flag: "${brightnessctl} -q ${flag} -d '*::kbd_backlight'";
  dpms = state: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${state}\" })'";
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
      pkgs.hypridle
      pkgs.grimblast
      pkgs.satty
      pyprland
    ];

    home.file = {
      ".config/pypr/config.toml".source = ./pyprland/pyprland.toml;
    };

    xdg.portal = {
      configPackages = [ hyprland-flake.hyprland ];
    };

    # The panel is an OLED on the laptops this runs on, so the lock screen is
    # black and lights as little as it can: a muted clock, and a password
    # field that only appears while typing.
    programs.hyprlock = {
      enable = true;
      settings = {
        general.hide_cursor = true;
        animations.enabled = false;
        background = [
          {
            monitor = "";
            color = "rgb(000000)";
          }
        ];
        # A clock and date in muted colours: enough to show the machine is
        # locked and not off, while lighting very few pixels.
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 72;
            font_family = lockFont;
            color = hyprlockColour palette.subtext;
            position = "0, 110";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:60000] date +'%A %-d %B'";
            font_size = 16;
            font_family = lockFont;
            color = hyprlockColour palette.muted;
            position = "0, 30";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "󰌾  Locked";
            font_size = 12;
            font_family = lockFont;
            color = hyprlockColour palette.muted;
            position = "0, 40";
            halign = "center";
            valign = "bottom";
          }
        ];
        # hyprland/lock-logo.svg, above the clock. `size` is its height.
        image = [
          {
            monitor = "";
            path = "${lockLogo}";
            size = 90;
            rounding = 0;
            border_size = 0;
            position = "0, 260";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "300, 50";
            position = "0, -60";
            halign = "center";
            valign = "center";
            outline_thickness = 2;
            fade_on_empty = true;
            placeholder_text = "";
            inner_color = "rgb(000000)";
            outer_color = hyprlockColour palette.primary;
            check_color = hyprlockColour palette.secondary;
            fail_color = hyprlockColour palette.error;
            font_color = hyprlockColour palette.text;
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${config.home.homeDirectory}/.config/wallpapers";
            fit_mode = "cover";
          }
        ];
      };
    };

    # Nothing else blanks the panel or suspends the machine when it is left
    # alone, which on battery is the biggest avoidable drain.
    services.hypridle = lib.mkIf isLaptop {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = dpms "on";
        };
        listener = [
          {
            timeout = 150;
            on-timeout = "${brightnessctl} -s set 10%";
            on-resume = "${brightnessctl} -r";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "${kbdBacklight "-s"} set 0; ${dpms "off"}";
            on-resume = "${dpms "on"}; ${kbdBacklight "-r"}";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
          }
        ];
      };
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

    wayland.windowManager.hyprland.extraConfig =
      themePrelude + builtins.readFile ./hyprland/hyprland.lua;
  };
}
