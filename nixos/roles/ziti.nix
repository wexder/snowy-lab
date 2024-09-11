{ config, pkgs, lib, openziti, ... }:
let
  cfg = config.roles.openziti;
in
{
  options.roles.openziti = {
    enable = lib.mkEnableOption "ziti";
  };

  config = (lib.mkIf cfg.enable {

    environment.systemPackages = [
      openziti.ziti-tunnel_latest
    ];

  });
}
