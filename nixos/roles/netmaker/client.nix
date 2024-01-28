{ config, pkgs, lib, ... }:
let
  cfg = config.roles.netmaker.client;
in
{
  options.roles.netmaker.client = {
    enable = lib.mkEnableOption "Enable Netmaker client";
    authkeyPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to netclient authkey secret";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable
    {
      services.netclient.enable = true;

      systemd.services.netclient-autoconnect = lib.mkIf (cfg.authkeyPath != null) {
        description = "Automatic connection to Netmaker";

        # Make sure tailscale is running before trying to connect.
        after = [ "network-pre.target" "netclinet.service" ];
        wants = [ "network-pre.target" "netclinet.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";

        script = ''
          nc=${pkgs.netclient}/bin/netclient

          # Wait for netclient to settle.
          sleep 2

          if $nc list | grep -q '{' ; then
            # Already online, do nothing.
            exit 0
          fi

          $nc join -t "$(< ${cfg.authkeyPath})"
        '';
      };
    };
}
