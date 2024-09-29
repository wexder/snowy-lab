{ lib, pkgs, config, modulesPath, nixos-hardware, ... }:
{
  boot.loader.systemd-boot.enable = true;

  imports =
    [
      ./common.nix
      ./bluetooth.nix
      ./hid.nix
      (modulesPath + "/installer/scan/not-detected.nix")
      ./drives/walrus.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  hardware.firmware = [ ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  gpus.intel.enable = true;
}
