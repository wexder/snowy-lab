{ config, lib, pkgs, ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";

    settings = [
      {
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.2;
          }
        ];
      }
      {
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.4;
            position = "5600,1231";
          }
          {
            criteria = "DP-8";
            mode = "3840x2160";
            position = "0,0";
          }
          {
            criteria = "DP-3";
            mode = "3440x1440";
            position = "2160,1231";
          }
        ];
      }
      {
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.4;
            position = "5600,1231";
          }
          {
            criteria = "DP-9";
            mode = "3840x2160";
            position = "0,0";
          }
          {
            criteria = "DP-6";
            mode = "3440x1440";
            position = "2160,1231";
          }
        ];

      }
    ];
  };
}
