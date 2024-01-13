{ lib, config, pkgs, modulesPath, ... }:
{
  boot.loader.systemd-boot.enable = true;

  imports =
    [
      ./common.nix
      ./bluetooth.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # linux 6.6 is wanky with amd gpu
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_5.override {
  #   argsOverride = rec {
  #     src = pkgs.fetchurl {
  #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
  #       sha256 = "sha256-ePvUOCL0xWvBbonoh0dn9ZJTLhoP/NGvTdJ5VZtfy7U=";
  #     };
  #     version = "6.5.13";
  #     modDirVersion = "6.5.13";
  #   };
  # });

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-jrxlrwz8iRumPc4FRlg9pyhDTbD19qVNl58l7Ef1SLM=";
      };
      version = "6.6.9";
      modDirVersion = "6.6.9";
    };
  });

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8812au
    rtl88xxau-aircrack
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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [{ device = "/swapfile"; size = 8192; }];

  gpus.amd.enable = true;
}
