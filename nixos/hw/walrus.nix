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
    ./drives/walrus.nix
    nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
  ];

  boot = {
    kernelParams = [
      # "acpi_osi="
      # "acpi_os_name=Linux"
      # "acpi_backlight=vendor"
      # "mem_sleep_default=deep"
      # "pcie_aspm=off"
      "intel_pstate=active"
      "resume=UUID=c63cb568-4363-42c8-a216-c88a8de825b2"
      "resume_offset=533760" # btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = ["xe"];
  boot.kernelModules = ["kvm-intel" "iwlwifi" "iwlmvm" "tuxedo_keyboard"];
  networking.networkmanager.wifi.backend = "iwd";
  boot.extraModulePackages = with config.boot.kernelPackages; [tuxedo-drivers cpupower x86_energy_perf_policy];
  hardware.firmware = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.thermald.enable = lib.mkDefault true;
  services.fstrim.enable = lib.mkDefault true;

  hardware.tuxedo-control-center.enable = true;
  hardware.tuxedo-drivers.enable = true;
  # hardware.tuxedo-rs = {
  #   enable = true;
  #   tailor-gui.enable = true;
  # };

  services.hardware.bolt.enable = true;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  gpus.intel.enable = true;
}
