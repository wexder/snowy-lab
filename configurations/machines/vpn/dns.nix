{ config, pkgs, ... }:
{

  users.users.pihole = {
    isNormalUser = true;
    home = "/home/pihole";
    description = "Pihole user";
    subUidRanges = [
      {
        count = 10;
        startUid = 6969;
      }
    ];
    subGidRanges = [
      {
        count = 10;
        startGid = 6969;
      }
    ];

  };

  services.pihole = {
    enable = true;
    hostConfig = {
      # define the service user for running the rootless Pi-hole container
      user = "pihole";
      enableLingeringForUser = true;

      # we want to persist change to the Pi-hole configuration & logs across service restarts
      # check the option descriptions for more information
      persistVolumes = true;

      # expose DNS & the web interface on unpriviledged ports on all IP addresses of the host
      # check the option descriptions for more information
      dnsPort = 5335;
      webPort = 8080;
    };
    piholeConfig = {
      tz = "Europe/Prague";
      web = {
        virtualHost = "pi.hole";
        password = "password";
      };
    };
  };
}
