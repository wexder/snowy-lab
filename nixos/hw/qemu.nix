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
          options = [ "NOPASSWD" "SETENV" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 2;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
