{ config, pkgs, lib, polymc, ... }:
let
  cfg = config.roles.games;
in
{
  options.roles.games = {
    enable = lib.mkEnableOption "Enable games";
  };

  config = lib.mkIf cfg.enable
    {
      nixpkgs.overlays = [ polymc.overlay ];

      # enable gamescope
      nixpkgs.config.packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
        };
      };

      programs.steam = {
        enable = true;
      };

      environment.systemPackages = with pkgs;[
        gamescope
        polymc
      ];

    };
}
