{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.mullvad;
in {
  options.roles.mullvad = {
    enable = lib.mkEnableOption "Enable mullvad vpn";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn = {
      enableEarlyBootBlocking = false;
      enableExcludeWrapper = false;
      enable = true;
    };

    environment.systemPackages = [
      pkgs.mullvad-vpn
    ];
  };
}
