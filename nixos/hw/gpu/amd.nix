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
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "amdgpu" ];
      # Enable OpenGL
      hardware.opengl = {
        enable = true;

        ## radv: an open-source Vulkan driver from freedesktop
        driSupport = true;
        driSupport32Bit = true;

        ## amdvlk: an open-source Vulkan driver from AMD
        extraPackages = with pkgs; [
          amdvlk
          rocm-opencl-icd
          rocm-opencl-runtime
          rocmPackages.clr.icd
        ];
        extraPackages32 = with pkgs;[
          driversi686Linux.amdvlk
        ];
      };

      boot.initrd.kernelModules = [ "amdgpu" ];
      environment.systemPackages = with pkgs;[
        amdvlk
        amdgpu_top
      ];

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
}
