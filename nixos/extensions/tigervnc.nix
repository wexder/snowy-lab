{ config, lib, pkgs, ... }:

let
  cfg = config.services.tigervnc;
in
{
  options = {
    services.tigervnc = {
      enable = lib.mkEnableOption "Enable Tigervnc";

      package = lib.mkPackageOption pkgs "tigervnc" { };

      config = lib.mkOption {
        default = ''
          session=plasma
          geometry=1920x1080
          localhost
          alwaysshared
        '';
        example = ''
          session=plasma
          geometry=1920x1080
          localhost
          alwaysshared
        '';
        type = lib.types.lines;
        description = lib.mdDoc ''
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.tigervnc" pkgs
        lib.platforms.linux)
    ];


    systemd.user.services.tigervnc = {
      Unit = {
        Description = "tigervnc - vncsession daemon";
        After = [ "network.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart =
          "${lib.getBin cfg.package}/bin/vncsession";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
