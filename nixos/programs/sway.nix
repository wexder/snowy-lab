{ config, lib, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./audio.nix
    ./desktop.nix
    ./mako.nix
    ./wofi.nix
    ./waybar.nix
    ./firefox.nix
  ];

  home.file.".config/sway/kill.sh".text = (builtins.readFile ./sway/kill.sh);
  home.file.".config/wallpapers".source = (pkgs.fetchFromGitHub {
    owner = "wexder";
    repo = "snowy-lab-wallpapers";
    rev = "740628d1f852c15d186fff559441cce3609aca3a";
    sha256 = "0qr0cg03rj9i9wb7q0s7xkjhmx4wmx37dnjdl1y2aahgc2r6cvm3";
  });

  home.packages = [
    pkgs.dbus # make dbus-update-activation-environment available in the path
    pkgs.kanshi
    pkgs.mako
    pkgs.wallutils
    pkgs.wl-clipboard
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.wdisplays
    pkgs.waypipe
    pkgs.dconf
    pkgs.swaylock
    pkgs.swayidle
    pkgs.dmenu
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = 1;
  };
  services.cliphist.enable = true;
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty";
      startup = [
        { command = "kdeconnect-indicator"; }
        { command = "mako"; }
        { command = "kanshi"; }
        { command = "slack"; }
        { command = "setrandom -m scale /home/wexder/.config/wallpapers"; }
        { command = "alacritty"; }

        ## cliphist
        { command = "wl-paste --type text --watch cliphist store #Stores only text data"; }
        { command = "wl-paste --type image --watch cliphist store #Stores only image data"; }

        # waybar
        { command = "waybar"; }

        # audio
        { command = "playerctld daemon"; }

        # browser
        { command = "firefox"; }

        # music
        { command = "tidal-hifi"; }

        # passwords
        # { command = "bitwarden"; }

        # steam
        { command = "steam"; }
      ];
      modes = {
        resize = {
          Left = "resize shrink width 10 px";
          Down = "resize grow height 10 px";
          Up = "resize shrink height 10 px";
          Right = "resize grow width 10 px";

          Escape = "mode default";
          Return = "mode default";
        };
      };
      bars = [ ];
      input = {
        "*" = {
          xkb_layout = "us,cz";
          xkb_options = "grp:win_space_toggle";
        };
      };
      gaps = {
        inner = 10;
      };
      # floating = {
      #   border = 0;
      # };
      window = {
        hideEdgeBorders = "smart";
        # border = 0;
        commands = [
          {
            command = "floating enable";
            criteria = {
              class = "xdg-desktop-portal-kde";
            };
          }
          {
            command = "floating enable";
            criteria = {
              class = "lutri";
            };
          }
          {
            command = "move to scratchpad";
            criteria = {
              class = "notion-app-enhanced";
            };
          }
          {
            command = "move to scratchpad";
            criteria = {
              title = "^TIDAL$";
            };
          }
        ];
      };
      colors = {
        focused = {
          border = "#eb4d4b";
          background = "#285577";
          text = "#ffffff";
          childBorder = "#d76a92";
          indicator = "#d76a92";
        };
      };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          # start a terminal
          "${modifier}+Return" = "exec alacritty";

          # kill focused window
          "${modifier}+q" = "kill";
          # "${modifier}+q" = "exec /wexder/home/.config/sway/kill.sh";

          # start your launcher
          "${modifier}+shift+d" = "exec wofi --show drun";

          # reload the configuration file
          "${modifier}+Shift+c" = "reload";

          # clipboard history
          "${modifier}+Shift+V" = "exec cliphist list | wofi -dmenu | cliphist decode | wl-copy";

          # Random wallpaper
          "Mod1+N" = "exec setrandom -m scale /wexder/home/.config/wallpapers";

          # exit sway (logs you out of your Wayland session)
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+F12" = "exec shutdown now";
          "${modifier}+Control+L" = "exec swaylock -f -i /wexder/home/.config/wallpapers/mountains-on-mars.png -s fill";
          "${modifier}+shift+return" = "exec thunar";
          "${modifier}+F2" = "exec cantata";
          "${modifier}+F3" = "exec mpv --player-operation-mode=pseudo-gui";
          "${modifier}+F4" = "exec firefox";
          "${modifier}+F5" = "exec kate";
          "${modifier}+F6" = "exec lutris";
          "${modifier}+F7" = "exec notify-send $(weather)";
          "${modifier}+F8" = "exec pkill kmousetool || kmousetool";
          "${modifier}+shift+F4" = "exec firefox --private-window";
          "Print" = "exec grim -g \"$(slurp)\" - | swappy -f -";
          "Control+Print" = "exec grim - | swappy -f -";
          "${modifier}+tab" = "workspace back_and_forth";

          #
          # Multimedia keys
          #

          # Pulse Audio controls
          # not working
          "--locked XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%"; #increase sound volume
          "--locked XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%"; #decrease sound volume
          "--locked XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound
          # Media --locked player controls
          "--locked XF86AudioPlay" = "exec playerctl play-pause";
          "--locked XF86AudioNext" = "exec playerctl next";
          # Lenov --locked  have phone instead of media keys
          "--locked XF86Phone" = "exec playerctl next";
          "--locked XF86AudioPrev" = "exec playerctl previous";
          # Lenov --locked  have phone instead of media keys
          "--locked XF86PickupPhone" = "exec playerctl previous";

          "--locked XF86MonBrightnessUp" = "exec brightnessctl set +2000";
          "--locked XF86MonBrightnessDown" = "exec brightnessctl set 2000-";

          #
          # Moving around:
          #
          # Move your focus around use $mod+[up|down|left|right]
          # "${modifier}+Left" = "focus left";
          # "${modifier}+Down" = "focus down";
          # "${modifier}+Up" = "focus up";
          # "${modifier}+Right" = "focus right";

          # focus seems to be swapped
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          # focus seems to be swapped
          "${modifier}+l" = "focus right";

          # _move_ the focused window with the same, but add Shift with arrow keys
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Control+less" = "move workspace to output left";
          "${modifier}+Control+greater" = "move workspace to output right";
          #
          # Workspaces:
          #
          # switch to workspace
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";
          # move focused container to workspace
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";
          # Note: workspaces can have any name you want, not just numbers.
          # We just use 1-10 as the default.
          #
          # Layout stuff:
          #
          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits
          # respectively.
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+t" = "tabbed";

          # Switch the current container between different layout styles
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Make the current focus fullscreen
          "F11" = "fullscreen";
          "${modifier}+Shift+f" = "fullscreen";

          # Toggle the current focus between tiling and floating mode
          "${modifier}+Shift+space" = "floating toggle";

          # Swap focus between the tiling area and the floating area
          "${modifier}+Mod1+space" = "focus mode_toggle";

          # move focus to the parent container
          "${modifier}+a" = "focus parent";
          #
          # Scratchpad:
          #
          # Sway has a "scratchpad", which is a bag of holding for windows.
          # You can send windows there and get them back later.

          # Move the currently focused window to the scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          "${modifier}+minus" = "scratchpad show";
        };
    };
    extraConfig = ''
      # set $gnome-schema org.gnome.desktop.interface
      #
      # exec_always {
      #     gsettings set $gnome-schema gtk-theme 'Catppuccin-Mocha-Standard-Pink-Dark'
      #         gsettings set $gnome-schema icon-theme 'Catppuccin-Mocha-Standard-Pink-Dark'
      #         gsettings set $gnome-schema cursor-theme 'Catppuccin-Mocha-Standard-Pink-Dark'
      #         gsettings set $gnome-schema font-name 'Catppuccin-Mocha-Standard-Pink-Dark'
      # }
      default_border pixel
      default_floating_border pixel
      hide_edge_borders --i3 smart
      titlebar_border_thickness 2
      titlebar_padding 2
      font monospace 0.1
    '';
  };

}
