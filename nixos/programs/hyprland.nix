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

  # TODO
  # home.file.".config/sway/kill.sh".text = (builtins.readFile ./sway/kill.sh);
  home.file.".config/wallpapers".source = (pkgs.fetchFromGitHub {
    owner = "wexder";
    repo = "snowy-lab-wallpapers";
    rev = "740628d1f852c15d186fff559441cce3609aca3a";
    sha256 = "0qr0cg03rj9i9wb7q0s7xkjhmx4wmx37dnjdl1y2aahgc2r6cvm3";
  });

  home.packages = with pkgs; [
    kanshi
    mako
    wallutils
    wl-clipboard
    libsForQt5.kdeconnect-kde
    wdisplays
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "hyprland";
    NIXOS_OZONE_WL = 1;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
    extraConfig = ''
      $mod = SUPER

      exec wayvnc

      bind = $mod, F, exec, firefox
    '';
  };

}
