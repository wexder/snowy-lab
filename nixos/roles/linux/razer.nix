{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.razer;
in
{
  options.roles.razer = {
    enable = lib.mkEnableOption "Enable dev tools";
  };

  config = lib.mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = [
        "wexder"
      ];
      batteryNotifier = {
        percentage = 15;
        frequency = 3600;
        enable = true;
      };
    };
    environment.systemPackages = [
      pkgs.polychromatic
    ];
  };
}
