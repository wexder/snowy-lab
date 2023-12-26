{ lib, config, pkgs, modulesPath, ... }:
{
  boot.loader.systemd-boot.enable = true;

  imports =
    [
      ./common.nix
      ./bluetooth.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [{ device = "/swapfile"; size = 16382; }];

  gpus.nvidia.enable = true;


  environment.systemPackages = with pkgs;[
    nut
  ];

  power.ups = {
    enable = true;
    mode = "netserver";
    upsmon = {
      powerValue = 2;
    };
    ups."serverups" = {
      driver = "usbhid-ups";
      port = "auto";
      description = "Server UPS";
    };
  };
}
