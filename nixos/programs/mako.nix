{
  config,
  lib,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
      sort = "-time";
      layer = "overlay";
      background-color = "#1f2530";
      width = 300;
      height = 110;
      border-size = 2;
      border-color = "#fb958b";
      border-radius = 15;
      icons = false;
      max-icon-size = 64;
      default-timeout = 5000;
      ignore-timeout = true;
      font = "monospace 12";
      markup = true;
    };
    criteria = {
      "urgency=low" = {
        border-color = "#fb958b";
      };

      "urgency=normal" = {
        border-color = "#ebcb8b";
      };

      "urgency=high" = {
        border-color = "#eb4d4b";
        default-timeout = 0;
      };

      "category=mpd" = {
        default-timeout = 2000;
        group-by = "category";
      };
    };
  };
}
