{ config, pkgs, ... }:

{
  imports = [ ];
  boot = {
    # kernelPackages = pkgs.linuxPackages_rpi4;
    tmp = {
      useTmpfs = true;
    };
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      # A lot GUI programs need this, nearly all wayland applications
      "cma=128M"
    ];
  };
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! Set to specific linux kernel version
  # boot.kernelPackages = pkgs.linuxPackages_5_4;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [{ device = "/swapfile"; size = 1024; }];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
    };
  };


  # virtualisation.docker.enable = true;

  # WiFi
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
      allowedTCPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o netmaker -j MASQUERADE
        iptables -A FORWARD -i netmaker -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -A FORWARD -i wlan0 -o netmaker -j ACCEPT
      '';
      extraStopCommands = ''
        iptables -D FORWARD -i netmaker -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -D FORWARD -i wlan0 -o netmaker -j ACCEPT
      '';
    };
    nat = {
      enable = true;
      internalIPs = [ "10.101.0.0/16" ];
      externalInterface = "netmaker";
    };
    # Enabling WIFI
    wireless.enable = true;
    wireless.interfaces = [ "wlan0" ];
    # If you want to connect also via WIFI to your router
    wireless.networks."MartinRouterKing".psk = "natoneprijdes";
    hostName = "pivpn"; # Define your hostname.
  };
  environment.systemPackages = with pkgs; [
    neovim
    netclient
  ];
  services.netclient = {
    enable = true;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9 wexder@archlinux"
  ];
  nix = {
    settings = {
      # auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
