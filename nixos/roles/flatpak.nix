{ config, pkgs, lib, ... }:
let
  cfg = config.roles.flatpak;
in
{
  options.roles.flatpak = {
    enable = lib.mkEnableOption "Enable flatpak";
  };

  config = lib.mkIf cfg.enable
    {
        services.flatpak.enable = true;
    };
}
