{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.laptop;
in {
  options.roles.laptop = {
    enable = lib.mkEnableOption "Enable laptop";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
    powerManagement.powertop.enable = true;
    powerManagement.enable = true;
    services.thermald.enable = true;
    services.cpupower-gui.enable = true;
    environment.systemPackages = [
      pkgs.brightnessctl
      pkgs.powertop
      pkgs.powerstat
      pkgs.auto-cpufreq
      config.boot.kernelPackages.cpupower
      config.boot.kernelPackages.x86_energy_perf_policy
    ];

    services.power-profiles-daemon.enable = false;
    services.auto-cpufreq.enable = false;

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "suspend";
    };

    services.tlp = {
      enable = true; # Enable TLP (better than gnomes internal power manager)
      pd = {
        enable = true;
      };
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_BAT = 0;

        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_BOOST_ON_AC = 1;

        PCIE_ASPM_ON_BAT = "powersupersave";
        WIFI_PWR_ON_BAT = "on";
        SOUND_POWER_SAVE_ON_BAT = 1;
        USB_AUTOSUSPEND = 1;
        RUNTIME_PM_ON_BAT = "auto";

        NMI_WATCHDOG = 0;
      };
    };

    # # Optimize wireless as per https://boilingsteam.com/a-quick-fix-to-improve-the-battery-life-of-the-amd-framework-13/
    systemd.services.disable_wireless = {
      enable = false;
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      description = "Disable wifi and bluetooth before suspend";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.util-linux}/bin/rfkill block all";
        ExecStop = "${pkgs.util-linux}/bin/rfkill unblock all";
      };
    };
  };
}
