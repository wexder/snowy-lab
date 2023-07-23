{ config, pkgs, ip, ... }:
{
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
      webProt = 8080;
    };
    piholeConfig.ftl = {
      # assuming that the host has this (fixed) IP and should resolve "pi.hole" to this address
      # check the option description & the FTLDNS documentation for more information
      LOCAL_IPV4 = ip;
    };
    piholeCOnfig.web = {
      virtualHost = "pi.hole";
      # TODO unsafe
      password = "password";
    };
  };
}
