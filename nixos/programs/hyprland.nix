{
  config,
  lib,
  pkgs,
  hyprland-flake,
  hyprland-plugins,
  ...
}:
let
  cfg = config.roles.desktop;
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

  # TODO
  # home.file.".config/sway/kill.sh".text = builtins.readFile ./sway/kill.sh;

  config = lib.mkIf (cfg.kind == "hyprland") {
    home.packages = [
      pkgs.kanshi
      pkgs.mako
      pkgs.hyprlock
      pkgs.hypridle
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland-flake.hyprland;
      portalPackage = hyprland-flake.xdg-desktop-portal-hyprland;
      plugins = hyprland-plugins;
      xwayland.enable = true;
      systemd.enable = true;
    };

    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      monitor = [
        ", highres, auto, 1.33"
      ];
      general = {
        layout = "hy3";
      };
      exec-once = [
      ];
      bezier = [
        "easeOutQuint,   0.23, 1,    0.32, 1"
      ];
      animation = [
        "workspaces, 0"
        "windows, 0"
      ];
      # Locked
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
      ];
      bind = [
        "$mod, RETURN, exec, ghostty"
        "$mod SHIFT, D, exec, wofi --show drun"
        "$mod SHIFT, V, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy"

        "$mod SHIFT, X, exit"

        "$mod, q, killactive"

        "$mod, e, hy3:changegroup, opposite"
        "$mod, s, hy3:changegroup, tab"
        "$mod, b, hy3:makegroup, tab, ephemeral"
        "$mod, p, hy3:locktab"

        "$mod SHIFT, SPACE, togglefloating,"

        # Move focus
        "$mod, l, hy3:movefocus, r"
        "$mod, h, hy3:movefocus, l"
        "$mod, k, hy3:movefocus, u"
        "$mod, j, hy3:movefocus, d"

        "$mod+Control_L, h, changegroupactive, b"
        "$mod+Control_L, l, changegroupactive, f"

        "$mod SHIFT, l, hy3:movewindow, r"
        "$mod SHIFT, h, hy3:movewindow, l"
        "$mod SHIFT, k, hy3:movewindow, u"
        "$mod SHIFT, j, hy3:movewindow, d"

        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      env = [
        "XCURSOR_SIZE,32"
      ];
      xwayland = {
        force_zero_scaling = true;
        use_nearest_neighbor = true;
        enabled = true;
      };
    };
  };
}
