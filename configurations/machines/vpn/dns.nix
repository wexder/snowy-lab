{ config, pkgs, ... }:
{
  services.coredns = {
    enable = true;
    config = ''
      (base) {

        }

        (google) {
            import base
        }

        . {
            forward . 192.168.1.52 8.8.8.8
            cache 60
            log
            errors
        }
    '';
  };
}
