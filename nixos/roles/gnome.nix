{ config, pkgs, lib, ... }:
let
  cfg = config.roles.gnome;
in
{
  options.roles.gnome = {
    enable = lib.mkEnableOption "Enable gnome";
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

    };
}
