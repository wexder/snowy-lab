{ config, pkgs, lib, ... }:
let
  cfg = config.roles.twingate;
in
{
  options.roles.twingate = {
    enable = lib.mkEnableOption "Enable twingate";
  };

  config = lib.mkIf cfg.enable
    {
      services.twingate = {
        enable = true;
      };
    };
}
