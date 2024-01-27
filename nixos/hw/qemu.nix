# QEMU Guest Hardware
{ lib, modulesPath, pkgs, ... }: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.useDHCP = false;

  # Hardware configuration
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "ahci" "xhci_pci" "virtio_pci" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  services.getty = {
    autologinUser = "wexder";
  };

  security.sudo.extraRules = [
    {
      users = [ "wexder" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 2;

  virtualisation.qemu.options = [
    "-m 8096"
    "-cpu host"
    "-smp 4"
  ];

  # without this the port forwarding  does not work, I cannot figure out why
  services.caddy = {
    enable = true;
  };
  virtualisation.forwardPorts = [
    { from = "host"; host.port = 2222; guest.port = 22; }
  ];

  services.greetd = {
    settings = {
      initial_session = {
        command = "zsh";
        user = "wexder";
      };
    };
  };

  # files for rebuilding
  environment.etc = {
    configuration = {
      source = ../templates/configuration.nix;
      target = "/nixos/configuration.nix";
    };
    flake = {
      source = ../templates/flake.nix;
      target = "/nixos/flake.nix";
    };
  };
}
