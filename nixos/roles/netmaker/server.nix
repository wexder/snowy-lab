{ config, pkgs, lib, ... }:
let
  cfg = config.roles.netmaker.server;
in
{
  options.roles.netmaker.server = {
    enable = lib.mkEnableOption "Enable Netmaker server";
  };

  config = lib.mkIf cfg.enable {
    services.netmaker.enable = true;
    services.netmaker.debugTools = true;
    services.netmaker.domain = "netmaker.neurobug.com";
    services.netmaker.email = "wexder19@gmail.com";
  };
}
