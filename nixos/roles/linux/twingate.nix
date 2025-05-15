{
  config,
  lib,
  ...
}: let
  cfg = config.roles.twingate;
in {
  config =
    lib.mkIf cfg.enable
    {
      networking.firewall.checkReversePath = lib.mkDefault "loose";
      services.resolved.enable = lib.mkIf (!config.networking.networkmanager.enable) true;
    };
}
