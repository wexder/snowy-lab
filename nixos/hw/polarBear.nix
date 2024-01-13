{ lib, config, pkgs, modulesPath, ... }:
{
  boot.loader.systemd-boot.enable = true;

  imports =
    [
      ./common.nix
      ./bluetooth.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

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

  environment.etc."passwordFile-ups".text = (builtins.readFile ./polarBear/ups-pass);

  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;
    upsmon = {
      monitor."serverups" = {
        system = "serverups@localhost:3493";
        user = "ups";
        passwordFile = "/etc/passwordFile-ups";
        powerValue = 2;
      };
    };
    upsd = {
      listen = [
        {
          address = "0.0.0.0";
          port = 3493;
        }
      ];
    };
    ups."serverups" = {
      driver = "usbhid-ups";
      port = "auto";
      description = "Server UPS";
      shutdownOrder = 0;
    };
  };
}
