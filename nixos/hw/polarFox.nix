{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}: {
  boot.loader.systemd-boot.enable = true;

  imports = [
    ./common.nix
    ./bluetooth.nix
    ./hid.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd" "iwlwifi" "iwlmvm"];
  boot.extraModulePackages = [
    # config.boot.kernelPackages.rtl8812au
    # config.boot.kernelPackages.rtl88xxau-aircrack
  ];
  hardware.ksm.enable = true;
  hardware.firmware = [
    pkgs.wireless-regdb
  ];

  fileSystems = {
    "/" = {
      # can I change this ?
      device = "/dev/disk/by-uuid/695f4364-cd08-40e3-9e01-b0f597240db6";
      fsType = "ext4";
    };

    "/boot" = {
      # can I change this ?
      device = "/dev/disk/by-uuid/EB21-55EC";
      fsType = "vfat";
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  gpus.amd.enable = true;
}
