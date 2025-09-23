{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.roles.games;
in
{
  options.roles.games = {
    enable = lib.mkEnableOption "Enable games";

    server = lib.mkOption {
      default = false;
      example = false;
      type = lib.types.bool;
    };
  };

  config =
    lib.mkIf cfg.enable
      (lib.mkMerge [
        {
          programs.steam = {
            enable = true;
          };
          programs.steam.gamescopeSession = {
            enable = true;
          };

          programs.gamemode.enable = true;

          environment.sessionVariables = {
            STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
          };

          environment.systemPackages = [
            pkgs.protonup
            pkgs.mangohud
            pkgs.gamescope
            pkgs.prismlauncher
            pkgs.lutris
            pkgs.moonlight-qt
          ];
        }
        (lib.mkIf cfg.server {
          services.sunshine = {
            enable = true;
            capSysAdmin = true;
            autoStart = true;
          };
        })
      ]);
}
