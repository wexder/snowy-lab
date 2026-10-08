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
  networking.networkmanager.wifi.backend = "iwd";
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.hardware.bolt.enable = true;

  networking.useDHCP = lib.mkDefault true;

  gpus.intel.enable = true;
}
