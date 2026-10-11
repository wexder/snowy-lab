{
  config,
  pkgs,
  lib,
  nixpkgs-lpmd,
  ...
}:
let
  cfg = config.roles.laptop;
in
{
  imports = [ "${nixpkgs-lpmd}/nixos/modules/services/hardware/intel-lpmd.nix" ];

  options.roles.laptop = {
    enable = lib.mkEnableOption "Enable laptop";
    intelLpmd = lib.mkEnableOption "Intel low power mode daemon (hybrid Intel CPUs only)";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
    powerManagement.powertop.enable = true;
    powerManagement.enable = true;
    services.thermald.enable = true;
    # services.cpupower-gui.enable = true;
    environment.systemPackages = [
      pkgs.brightnessctl
      pkgs.powertop
      pkgs.powerstat
      config.boot.kernelPackages.cpupower
      config.boot.kernelPackages.x86_energy_perf_policy
    ];

    # power-profiles-daemon drives EPP and the ACPI platform profile, and is what
    # the quickshell control center's Saver/Balanced/Performance switch talks to.
    # Balanced already drops to EPP balance_power on battery, which keeps turbo
    # and the full frequency range available — no hard caps, so no sluggishness.
    services.power-profiles-daemon.enable = true;

    # Experimental: on Panther Lake this moves the SoC power slider with the
    # firmware workload hints instead of leaving it fixed per profile. Upstream
    # ships every profile switched off; auto on the two battery-relevant ones is
    # what CachyOS does. Keep only if powerstat shows it earns its place.
    services.intel-lpmd = lib.mkIf cfg.intelLpmd {
      enable = true;
      package = pkgs.callPackage "${nixpkgs-lpmd}/pkgs/by-name/in/intel-lpmd/package.nix" { };
      overrideDefaults = {
        BalancedDef = 0;
        PowersaverDef = 0;
      };
    };

    # powertop --auto-tune also autosuspends USB keyboards and mice, which makes
    # them drop the first input after every couple of idle seconds. Keep runtime
    # PM for everything else and turn it back off for HID devices.
    systemd.services.powertop.serviceConfig.ExecStartPost =
      pkgs.writeShellScript "powertop-keep-hid-awake" ''
        for iface in /sys/bus/usb/devices/*:*; do
          if [ "$(cat "$iface/bInterfaceClass" 2>/dev/null)" = "03" ]; then
            echo on > "$iface/../power/control" || true
          fi
        done
      '';
  };
}
