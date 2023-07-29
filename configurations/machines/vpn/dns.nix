{ config, pkgs, ... }:
{
  services.coredns = {
    enable = true;
    config = ''
      . {
          forward . 192.168.1.52 8.8.8.8
          log
          errors
      }
    '';
  };
}
