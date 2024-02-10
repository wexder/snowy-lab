{ lib, pkgs, config, modulesPath, nixos-hardware, ... }:
{
  boot.loader.systemd-boot.enable = true;

  imports =
    [
      ./common.nix
      ./bluetooth.nix
      (modulesPath + "/installer/scan/not-detected.nix")
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  hardware.firmware = [ ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/de7f2b18-57f3-429f-bdfa-32f03462fe35";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [{ device = "/swapfile"; size = 8192; }];

  gpus.intel.enable = true;
}
