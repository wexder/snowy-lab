{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.logitech;
in
{
  options.roles.logitech = {
    enable = lib.mkEnableOption "Enable dev tools";
  };

  config = lib.mkIf cfg.enable {
    services.ratbagd.enable = true;
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    environment.systemPackages = [
      pkgs.piper
    ];

  };
}
