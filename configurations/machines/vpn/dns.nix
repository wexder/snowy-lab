{ config, pkgs, ... }:
{
  services.coredns = {
    enable = true;
    config = ''
      . {
          forward . 192.168.1.52 {
            health_check 5s
            policy sequential
          }
          forward . 8.8.8.8 {
            health_check 5s
            policy sequential
          }
          log
          errors
      }
    '';
  };
}
