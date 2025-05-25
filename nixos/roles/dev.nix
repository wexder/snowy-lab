{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.dev;
in {
  options.roles.dev = {
    enable = lib.mkEnableOption "Enable dev tools";
    android = lib.mkEnableOption "Enable android dev tools";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
