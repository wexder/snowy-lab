{ config, lib, pkgs, ... }:
{
  services.mako = {
    enable = true;
    sort = "-time";
    layer = "overlay";
    backgroundColor = "#1f2530";
    width = 300;
    height = 110;
    borderSize = 2;
    borderColor = "#fb958b";
    borderRadius = 15;
    icons = false;
    maxIconSize = 64;
    defaultTimeout = 5000;
    ignoreTimeout = true;
    font = "monospace 12";
    markup = true;
    extraConfig = ''
      [urgency=low]
      border-color=#fb958b

      [urgency=normal]
      border-color=#ebcb8b

      [urgency=high]
      border-color=#eb4d4b
      default-timeout=0

      [category=mpd]
      default-timeout=2000
      group-by=category
    '';
  };
}
