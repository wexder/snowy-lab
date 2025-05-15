{
  config,
  lib,
  ...
}: let
  cfg = config.roles.officeWg;
in {
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [51820];
  };
}
