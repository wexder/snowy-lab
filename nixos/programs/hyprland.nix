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
        gaps_in = 5;
        gaps_out = 10;
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
        "$mod, RETURN, exec, ghostty +new-window"
        "$mod SHIFT, RETURN, exec, thunar"
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

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];
      decoration = {
        rounding = 4;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      misc = {
        vrr = 3;
      };
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
