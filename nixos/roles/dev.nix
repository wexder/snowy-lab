{ config, pkgs, lib, ... }:
let
  cfg = config.roles.dev;
in
{
  options.roles.dev = {
    enable = lib.mkEnableOption "Enable dev tools";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs;[
        postgres
        kubectl
      ];
    };
}