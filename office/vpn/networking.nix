{ pkgs, ip, ... }: {

  # point local resolvectl to coredns
  networking.resolvconf.useLocalResolver = true;
  networking.networkmanager.insertNameservers = [ "127.0.0.1" ];

  networking.ucarp = {
    enable = true;
    interface = "enX0";
    srcIp = ip;
    addr = "192.168.240.250";
    vhId = 250; # not sure what this is
    passwordFile = builtins.toString (pkgs.writeText "ucarp-pass" "test"); # TODO move to agenix
    upscript = pkgs.writeScript "upscript" ''
      #!/bin/sh
      ${pkgs.iproute2}/bin/ip addr add "$2"/24 dev "$1"
    '';
    downscript = pkgs.writeScript "downscript" ''
      #!/bin/sh
      ${pkgs.iproute2}/bin/ip addr del "$2"/24 dev "$1"
    '';
  };

  systemd.services.ucarp = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "300ms";
      StartLimitBurst = 1000;
    };
  };
}
