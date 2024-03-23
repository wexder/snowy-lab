{ config, pkgs, lib, ... }:
let
  cfg = config.roles."3d";
in
{
  options.roles."3d" = {
    enable = lib.mkEnableOption "Enable 3D software";
  };

  config = lib.mkIf cfg.enable
    {

      environment.systemPackages = [
        pkgs.bambu-studio
      ];
    };
}
