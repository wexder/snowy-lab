{ config, pkgs, lib, ... }:
let
  cfg = config.gpus.amd;
in
{
  options.gpus.amd = {
    enable = lib.mkEnableOption "Enable amd gpu";
    rocm = lib.mkEnableOption "Enable amd rocm";
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.xserver.enable = true;
        services.xserver.videoDrivers = [ "amdgpu" ];
        # Enable OpenGL
        hardware.graphics = {
          enable = true;
          enable32Bit = true;

          ## amdvlk: an open-source Vulkan driver from AMD
          extraPackages = [
            # pkgs.amdvlk
            # pkgs.rocm-opencl-runtime
            # pkgs.rocm-opencl-icd
            # pkgs.rocmPackages.rocm-runtime
          ];
          extraPackages32 = [
            # pkgs.driversi686Linux.amdvlk
          ];
        };

        boot.initrd.kernelModules = [ "amdgpu" ];
        environment.systemPackages = [
          pkgs.amdgpu_top
          pkgs.clinfo
        ];
      }

      (lib.mkIf cfg.rocm
        {
          hardware.graphics = {
            extraPackages = [
              pkgs.rocm-opencl-icd
            ];
          };

          environment.systemPackages = [
            pkgs.rocmPackages.rocminfo
          ];

          systemd.tmpfiles.rules = [
            "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
          ];
        }
      )
    ]);
}
