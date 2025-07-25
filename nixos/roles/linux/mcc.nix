{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.mccDev;
in {
  options.roles.mccDev = {
    enable = lib.mkEnableOption "Enable mcc dev tools";
    use_netbird = lib.mkOption {
      default = false;
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (cfg.use_netbird == false) {
        age = {
          secrets = {
            mccVPN.file = ../../secrets/mcc_openvpn.age;
            mccVPNAuth.file = ../../secrets/mcc_openvpn_auth.age;
          };
        };

        services.openvpn.servers = {
          mccVPN = {
            config = ''
              config ${config.age.secrets.mccVPN.path}
              auth-user-pass ${config.age.secrets.mccVPNAuth.path}
            '';
          };
        };
      })
      (lib.mkIf (cfg.use_netbird == true) {
        services.netbird.clients = {
          mcc = {
            name = "mcc";
            port = 51823;
            ui.enable = true;
            service.name = "mcc";
            openFirewall = true;
          };
        };
      })
    ]
  );
}
