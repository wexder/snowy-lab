{ config, pkgs, lib, ... }:
let
  cfg = config.roles.laptop;
in
{
  options.roles.laptop = {
    enable = lib.mkEnableOption "Enable laptop";
  };

  config = lib.mkIf cfg.enable
    {
        # powerManagement.powertop.enable = true;

# services.auto-cpufreq.enable = true;
# services.auto-cpufreq.settings = {
#   battery = {
#      governor = "powersave";
#      turbo = "never";
#   };
#   charger = {
#      governor = "performance";
#      turbo = "auto";
#   };
# };
# services.tlp.enable = true;

    };
}
