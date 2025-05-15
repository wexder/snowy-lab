{ config, pkgs, lib, ... }:
let
  cfg = config.roles.xMinimalDesktop;
in
{
  options.roles.xMinimalDesktop = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;
      services.displayManager.defaultSession = "plasmawayland";

      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "startplasma-x11";
      services.xrdp.openFirewall = true;

      environment.systemPackages = [pkgs.firefox];

      environment.plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        gwenview
        okular
        oxygen
        khelpcenter
        konsole
        plasma-browser-integration
        print-manager
      ];
    };
}
