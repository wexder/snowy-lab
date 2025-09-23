{
  modulesPath,
  config,
  lib,
  pkgs,
  latestPkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../common/xen.nix
    ../../vpn
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  boot = {
    # Add kernel modules detected by nixos-generate-config:
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9"
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  system.stateVersion = "23.11";

  virtualisation.xen.guest = {
    enable = true;
    recommendedHVMSettings = true;
  };

  age = {
    identityPaths = [
      "/root/.ssh/id_ed25519"
    ];
  };
}
