{ lib, config, pkgs, modulesPath, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.pulseaudio.extraConfig = "
  load-module module-switch-on-connect
";
}
