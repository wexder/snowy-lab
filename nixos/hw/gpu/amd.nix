{ config, pkgs, lib, ... }:
let
  cfg = config.gpus.amd;
in
{
  options.gpus.amd = {
    enable = lib.mkEnableOption "Enable amd gpu";
  };

  config = lib.mkIf cfg.enable
    {
      # Enable OpenGL
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      boot.initrd.kernelModules = [ "amd" ];

      environment.systemPackages = with pkgs;[
        amdvlk
        amdgpu_top
      ];

      hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
}
