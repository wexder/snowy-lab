{ config, pkgs, lib, ... }:
let
  cfg = config.roles.games;
in
{
  options.roles.games = {
    enable = lib.mkEnableOption "Enable games";
  };

  config = lib.mkIf cfg.enable
    {
      programs.steam = {
        enable = true;
      };
      programs.steam.gamescopeSession = {
        enable = true;
      };

      programs.gamemode.enable = true;

      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
          "\${HOME}/.steam/root/compatibilitytools.d";
      };

      environment.systemPackages = [
        pkgs.protonup
        pkgs.mangohud
        pkgs.gamescope
        pkgs.prismlauncher
        pkgs.lutris
      ];

    };
}
