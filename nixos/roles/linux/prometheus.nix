{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.prometheus;
in {
  options.roles.prometheus = {
    enable = lib.mkEnableOption "Enable prometheus";
    nut = lib.mkEnableOption "Enable prometheus";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.prometheus.exporters.node = {
          enable = true;
          port = 40001;
          enabledCollectors = [
            "processes"
            "systemd"
          ];
        };
      }
      (
        lib.mkIf cfg.nut
        {
          services.prometheus.exporters.nut = {
            enable = true;
            port = 40002;
            nutUser = "ups";
            passwordPath = /etc/passwordFile-ups;
          };
        }
      )
    ]
  );
}
