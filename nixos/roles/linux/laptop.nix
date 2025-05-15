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
      # services.thermald.enable = true;
      services.cpupower-gui.enable = true;
      environment.systemPackages = [
        pkgs.powertop
        pkgs.powerstat
      ];

      # services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles - thanks System76!!!

      # services.auto-cpufreq.enable = true;
      # services.auto-cpufreq.settings = {
      #   battery = {
      #     governor = "powersave";
      #     turbo = "never";
      #   };
      #   charger = {
      #     governor = "performance";
      #     turbo = "auto";
      #   };
      # };
    };
}
