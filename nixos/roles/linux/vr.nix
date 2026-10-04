{
  config,
  pkgs,
  lib,
  xr_pkgs,
  ...
}:
let
  cfg = config.roles.vr;
in
{
  options.roles.vr = {
    enable = lib.mkEnableOption "Enable VR";
  };

  config = lib.mkIf cfg.enable {
    services.wivrn = {
      package = xr_pkgs.wivrn;
      enable = true;
      steam.enable = true;
    };
  };
}
