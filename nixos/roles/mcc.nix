{ config, pkgs, lib, ... }:
let
  cfg = config.roles.mccDev;
in
{
  options.roles.mccDev = {
    enable = lib.mkEnableOption "Enable mcc dev tools";
  };

    config = lib.mkIf cfg.enable{
      age = {
        secrets = {
          mccVPN.file = ../secrets/mcc_openvpn.age;
          mccVPNAuth.file = ../secrets/mcc_openvpn_auth.age;
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
    };
}
