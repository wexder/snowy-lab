{ config, pkgs, lib, ... }:
let
  cfg = config.roles.cad;
in
{
  options.roles.cad = {
    enable = lib.mkEnableOption "Enable CAD software";
  };

  config = lib.mkIf cfg.enable
    {

      environment.systemPackages = [
        pkgs.freecad
        pkgs.kicad
      ];
    };
}
