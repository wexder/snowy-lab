{ config, pkgs, lib, ... }:
let
  cfg = config.roles.netclient;
in
{
  options.roles.netclient = {
    enable = lib.mkEnableOption "Enable netclient";
  };

  config = lib.mkIf cfg.enable
    {
      services.netclient = {
        enable = true;
      };
    };
}
