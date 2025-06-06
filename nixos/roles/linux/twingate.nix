{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roles.twingate;
in {
  options.roles.twingate = {
    enable = lib.mkEnableOption "Enable twingate";
    package = lib.mkPackageOption pkgs "twingate" {};
  };

  config =
    lib.mkIf cfg.enable
    {
      systemd.packages = [cfg.package];
      systemd.services.twingate = {
        preStart = "cp -r --update=none ${cfg.package}/etc/twingate/. /etc/twingate/";
        wantedBy = ["multi-user.target"];
        after = ["wg-quick-officeWg0.service"];
      };

      networking.firewall.checkReversePath = lib.mkDefault "loose";
      services.resolved.enable = lib.mkIf (!config.networking.networkmanager.enable) true;

      environment.systemPackages = [cfg.package]; # For the CLI.
    };
}
