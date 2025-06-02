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

  config =
    lib.mkIf cfg.enable
    {
      services.upower.enable = true;
      powerManagement.powertop.enable = true;
      powerManagement.enable = true;
      services.thermald.enable = true;
      services.cpupower-gui.enable = true;
      environment.systemPackages = [
        pkgs.powertop
        pkgs.powerstat
        pkgs.auto-cpufreq
      ];

      # services.auto-cpufreq = {
      #   enable = true;
      #   settings = {
      #     battery = {
      #       governor = "powersave";
      #       energy_performance_preference = "power";
      #       energy_perf_bias = "power";
      #       scaling_max_freq = 1000000;
      #       turbo = "never";
      #     };
      #     charger = {
      #       governor = "performance";
      #       turbo = "auto";
      #     };
      #   };
      # };

      services.tlp = {
        enable = true; # Enable TLP (better than gnomes internal power manager)
        settings = {
          TLP_DEFAULT_MODE = "BAT";
          TLP_PERSISTENT_DEFAULT = 1;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          START_CHARGE_THRESH_BAT0 = 80;
          STOP_CHARGE_THRESH_BAT0 = 100;
        };
      };

      # Optimize wireless as per https://boilingsteam.com/a-quick-fix-to-improve-the-battery-life-of-the-amd-framework-13/
      systemd.services.disable_wireless = {
        enable = true;
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
