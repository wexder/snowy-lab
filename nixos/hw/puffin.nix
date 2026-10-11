{
  lib,
  config,
  modulesPath,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;

  imports = [
    ./common.nix
    ./bluetooth.nix
    ./hid.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ./drives/puffin.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  # Panel Replay is broken on Panther Lake with the 7.2 xe driver: boot logs
  # "Selective fetch area calculation failed in pipe A", the display interrupt
  # never goes quiet and the package stays out of its deep idle states. Turning
  # only Panel Replay off lets the driver fall back to PSR2. Re-test without
  # this after kernel updates.
  boot.kernelParams = [ "xe.enable_panel_replay=0" ];
  networking.networkmanager.wifi.backend = "iwd";
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.hardware.bolt.enable = true;

  networking.useDHCP = lib.mkDefault true;

  gpus.intel.enable = true;
}
