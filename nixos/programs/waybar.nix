{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./waybar/style.css);
    # style = (builtins.readFile ./waybar/dark.css);
    settings = {
      mainBar = {
        layer = "top";
        height = 30; # Waybar height (to be removed for auto height)
        margin-top = 0;
        margin-left = 0;
        margin-bottom = 0;
        margin-right = 0;
        spacing = 5; # Gaps between modules (4px)
        modules-left = [ "sway/workspaces" "cpu" "memory" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "tray" "backlight" "pulseaudio" "network" "sway/language" "battery" "clock" "custom/power-menu" ];
        "sway/window" = {
          format = "{title}";
          max-length = 50;
        };
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };
        "sway/language" = {
          format = "{short} {variant}";
        };
        "sway/mode" = {
          format = " {}";
          max-length = 50;
        };
        tray = {
          spacing = 10;
        };
        clock = {
          format = "<span color='#bf616a'> </span>{:%a %b %d %I:%M %p}";
          format-alt = "<span color='#bf616a'> </span>{:%I:%M %p}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          timezone = "Europe/Prague";
        };
        cpu = {
          interval = 10;
          format = " {}%";
          max-length = 10;
          on-click = "";
        };
        memory = {
          interval = 30;
          format = " {}%";
          format-alt = " {used:0.1f}G";
          max-length = 10;
        };
        backlight = {
          device = "eDP-1";
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          on-click = "";
        };
        network = {
          format-wifi = "直 {signalStrength}%";
          format-ethernet = " wired";
          # on-click =  "wofi-wifi-menu",
          format-disconnected = "Disconnected  ";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "  {volume}%";
          format-bluetooth-muted = " ";
          format-muted = "婢";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          on-click-right = "blueberry";
        };
        battery = {
          bat = "BAT0";
          adapter = "ADP0";
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          max-length = 20;
          format = "{icon} {capacity}%";
          format-warning = "{icon} {capacity}%";
          format-critical = "{icon} {capacity}%";
          format-charging = "<span font-family='Font Awesome 6 Free'></span> {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon} {time}";
          format-full = "  {capacity}%";
          format-icons = [ " " " " " " " " " " ];
        };
      };
    };
  };
}
