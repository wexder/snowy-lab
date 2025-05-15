{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.lan-mouse;
  configFile = pkgs.writeText "config.toml" cfg.config;
in {
  options.services.lan-mouse = {
    enable = mkEnableOption (lib.mdDoc "Lan mouse service");

    config = mkOption {
      default = "";
      example = ''
        # example configuration

        # configure release bind
        release_bind = [ "KeyA", "KeyS", "KeyD", "KeyF" ]

        # optional port (defaults to 4242)
        port = 4242
        # # optional frontend -> defaults to gtk if available
        # # possible values are "cli" and "gtk"
        # frontend = "gtk"

        # define a client on the right side with host name "iridium"
        [right]
        # hostname
        hostname = "iridium"
        # activate this client immediately when lan-mouse is started
        activate_on_startup = true
        # optional list of (known) ip addresses
        ips = ["192.168.178.156"]

        # define a client on the left side with IP address 192.168.178.189
        [left]
        # The hostname is optional: When no hostname is specified,
        # at least one ip address needs to be specified.
        hostname = "thorium"
        # ips for ethernet and wifi
        ips = ["192.168.178.189", "192.168.178.172"]
        # optional port
        port = 4242
      '';
      type = types.lines;
      description = lib.mdDoc ''
        Example lan mouse config to use.
        See <https://github.com/feschber/lan-mouse?tab=readme-ov-file#example-config> for details.
      '';
    };

    package = mkPackageOption pkgs "lan-mouse" {};

    extraArgs = mkOption {
      default = ["--daemon"];
      example = ["--daemon"];
      type = types.listOf types.str;
      description = lib.mdDoc "Extra arguments to pass to lan-mouse.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lan-mouse = {
      description = "Lan mouse daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        PermissionsStartOnly = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        CapabilityBoundingSet = "cap_net_bind_service";
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        DynamicUser = true;
        ExecStart = "${getBin cfg.package}/bin/lan-mouse --config=${configFile} ${lib.escapeShellArgs cfg.extraArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
