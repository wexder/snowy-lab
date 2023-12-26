{ config, pkgs, lib, ... }:
let
  cfg = config.roles.prometheus;
in
{
  options.roles.prometheus = {
    enable = lib.mkEnableOption "Enable prometheus";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.prometheus.exporters.node = {
          enable = true;
          port = 40001;
        };
      }
    ])
  ;
}
