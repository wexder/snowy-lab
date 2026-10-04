{
  config,
  stable,
  lib,
  ...
}:
let
  cfg = config.roles.wine;
in
{
  options.roles.wine = {
    enable = lib.mkEnableOption "Wine";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      stable.icoutils
      stable.wine-wayland
      stable.winetricks
      stable.wineWow64Packages.waylandFull
      stable.wineWow64Packages.fonts
      stable.playonlinux
      stable.vkd3d
      stable.vkdt
      stable.dxvk
      stable.q4wine # testing
      # stable.bottles # testing
    ];
  };
}
