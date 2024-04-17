{ config, lib, pkgs, ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";

    profiles = {
      default = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.4;
            status = "enable";
          }
        ];
      };

      office = { };
    };
  };
}
