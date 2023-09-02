{ config, pkgs, lib, ... }:
let
  cfg = config.roles.amdgpu;
in
{
  options.roles.amdgpu = {
    enable = lib.mkEnableOption "Enable amd gpu";
  };

  config = lib.mkIf cfg.enable
    {
      boot.initrd.kernelModules = [ "amdgpu" ];

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

      hardware.opengl.enable = true;

      hardware.opengl.driSupport = true;
      # For 32 bit applications
      hardware.opengl.driSupport32Bit = true;
    };
}
