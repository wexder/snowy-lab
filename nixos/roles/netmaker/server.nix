{ config, pkgs, lib, ... }:
let
  cfg = config.roles.netmaker.server;
in
{
  options.roles.netmaker.server = {
    enable = lib.mkEnableOption "Enable Netmaker server";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/pull/283768 has to be merged
    services.netmaker = {
      enable = true;
      debugTools = true;
      domain = "netmaker.neurobug.com";
      email = "wexder19@gmail.com";
    };
  };
}
