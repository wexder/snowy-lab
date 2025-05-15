{
  lib,
  config,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}: {
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  imports = [
    ./common.nix
    ./drives/test-server.nix
    # nixos-hardware.nixosModules.lenovo-ideapad-slim-5
  ];

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "iwlwifi" "iwlmvm"];
  networking.networkmanager.wifi.backend = "iwd";
  boot.extraModulePackages = [];
  hardware.enableRedistributableFirmware = true;

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
