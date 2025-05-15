{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.videoEditing;
in {
  options.roles.videoEditing = {
    enable = lib.mkEnableOption "Enable video editing software";
  };

  config =
    lib.mkIf cfg.enable
    {
      environment.systemPackages = [
        # davinci-resolve
        # pkgs.blender-hip
        # blender
        pkgs.movit
        pkgs.kdePackages.kdenlive
      ];
    };
}
