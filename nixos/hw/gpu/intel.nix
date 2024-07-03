{ config, pkgs, lib, ... }:
let
  cfg = config.gpus.intel;
in
{
  options.gpus.intel = {
    enable = lib.mkEnableOption "Enable amd intel";
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "intel" ];
      # Enable OpenGL
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          pkgs.intel-media-driver # LIBVA_DRIVER_NAME=iHD
          pkgs.vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          pkgs.vaapiVdpau
          pkgs.libvdpau-va-gl
        ];
      };
    };
}
