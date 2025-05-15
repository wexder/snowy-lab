{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles."3d";
  bambu = pkgs.bambu-studio.overrideAttrs (previousAttrs: {
    version = "01.00.01.50";
    src = pkgs.fetchFromGitHub {
      owner = "bambulab";
      repo = "BambuStudio";
      rev = "v01.00.01.50";
      hash = "sha256-7mkrPl2CQSfc1lRjl1ilwxdYcK5iRU//QGKmdCicK30=";
    };
  });
in {
  options.roles."3d" = {
    enable = lib.mkEnableOption "Enable 3D software";
  };

  config =
    lib.mkIf cfg.enable
    {
      environment.systemPackages = [
        bambu
      ];
    };
}
