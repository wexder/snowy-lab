{ config, pkgs, lib, ... }:
let
  cfg = config.roles.tailscale;
in
{
  options.roles.tailscale = {
    enable = lib.mkEnableOption "Enable tailscale";
  };

  config = lib.mkIf cfg.enable
    {
      services.tailscale = {
        enable = true;
      };
    };
}
