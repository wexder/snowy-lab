{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.dns;
in {
  options.roles.dns = {
    enable = lib.mkEnableOption "Coredns server";

    forwardIP = lib.mkOption {
      type = lib.types.str;
      example = "192.168.1.52";
      description = "Forward IP";
    };
  };

  config =
    lib.mkIf cfg.enable
    {
      services.coredns = {
        enable = true;
        config = ''
          . {
              forward . ${cfg.forwardIP} 8.8.8.8 {
                health_check 5s
                policy sequential
              }
              log
              errors
          }
        '';
      };
    };
}
