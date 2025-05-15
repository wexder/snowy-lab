{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.aerospace;
in {
  options.roles.aerospace = {
    enable = lib.mkEnableOption "Enable aerospace";
  };

  config =
    lib.mkIf cfg.enable
    {
      services.jankyborders = {
        enable = true;
      };
      services.aerospace = {
        enable = true;
        settings = {
          start-at-login = true;
          mode.main.binding = {
            alt-e = "layout tiles horizontal vertical";
            alt-s = "layout accordion vertical";

            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            alt-1 = "workspace 1";
            alt-shift-1 = "move-node-to-workspace 1";
            alt-2 = "workspace 2";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-3 = "workspace 3";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-4 = "workspace 4";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-5 = "workspace 5";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-6 = "workspace 6";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-7 = "workspace 7";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-8 = "workspace 8";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-9 = "workspace 9";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-0 = "workspace 0";
            alt-shift-0 = "move-node-to-workspace 0";
          };
        };
      };
    };
}
