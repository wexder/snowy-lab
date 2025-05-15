{
  config,
  stable,
  lib,
  ...
}: let
  cfg = config.roles.wine;
in {
  options.roles.wine = {
    enable = lib.mkEnableOption "Wine";
  };

  config =
    lib.mkIf cfg.enable
    {
      environment.systemPackages = [
        # pkgs.wine-wayland
        stable.winetricks
        stable.wineWowPackages.waylandFull
        stable.wineWowPackages.fonts
        stable.playonlinux
        # pkgs.vkd3d
        # pkgs.vkdt-wayland
        # pkgs.dxvk
        stable.q4wine # testing
        # stable.bottles # testing
      ];
    };
}
