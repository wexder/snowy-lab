{ config, pkgs, lib, ... }:
let
  cfg = config.roles.videoEditing;
in
{
  options.roles.videoEditing = {
    enable = lib.mkEnableOption "Enable video editing software";
  };

  config = lib.mkIf cfg.enable
    {

      environment.systemPackages = with pkgs;[
        lightworks
        blender-hip
        davinci-resolve
        kdenlive
      ];
    };
}
