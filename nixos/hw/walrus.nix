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
      # "acpi.ec_no_wakeup=1" # Fixes ACPI wakeup issues
      "mem_sleep_default=deep"
      # "pcie_aspm=off"
      "pcie_aspm.policy=powersupersave"
      # "intel_pstate=active"
      "resume=UUID=c63cb568-4363-42c8-a216-c88a8de825b2"
      "resume_offset=533760" # btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };
  boot.blacklistedKernelModules = [
    "asus_wmi"
    "asus_nb_wmi"
  ];

  boot.kernel.sysctl."vm.dirty_writeback_centisecs" = 1500;

  boot.extraModprobeConfig = ''
    blacklist asus_wmi
    blacklist asus_nb_wmi

    install asus_wmi ${pkgs.coreutils}/bin/false
    install asus_nb_wmi ${pkgs.coreutils}/bin/false
  '';

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [
    "xe"
    "acpi_call"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "iwlwifi"
    "iwlmvm"
    "tuxedo_keyboard"
    "tuxi_acpi"
  ];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  networking.networkmanager.wifi.backend = "iwd";
  boot.extraModulePackages = with config.boot.kernelPackages; [
    tuxedo-drivers
    acpi_call
    yt6801
  ];
  hardware.firmware = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  #Use periodic trim instead of continuous async discard:
  services.fstrim.enable = lib.mkDefault true;

  services.intel-lpmd = {
    enable = true;
    config.meteorLake = true; # meteorLake / lunarLake / pantherLake / experimental / custom
    mode = "AUTO"; # ON / OFF / AUTO
    debug = false;
  };
  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    MemorySleepMode = "deep";
    HibernateDelaySec = "60m";
  };

  hardware.tuxedo-control-center.enable = true;
  hardware.tuxedo-drivers.enable = true;

  services.hardware.bolt.enable = true;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  gpus.intel.enable = true;
}
