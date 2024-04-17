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
  boot.kernelModules = [ "kvm-amd" ];
  hardware.firmware = [ ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/13dc5bc5-7334-432a-89b8-8b22cce3e7ce";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [{ device = "/swapfile"; size = 32768; }];

  gpus.amd.enable = true;
}
