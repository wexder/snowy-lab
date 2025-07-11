{
  lib,
  pkgs,
  config,
  modulesPath,
  nixos-hardware,
  ...
}: {
  boot.loader.systemd-boot.enable = true;

  imports = [
    ./common.nix
    ./bluetooth.nix
    ./hid.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ./drives/snowflake.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "iwlwifi" "iwlmvm"];
  hardware.firmware = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.networkmanager.wifi.backend = "iwd";

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  gpus.intel.enable = true;
}
