{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];
  networking.hostName = "pivpn";
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
      allowedTCPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o netmaker -j MASQUERADE
        iptables -A FORWARD -i netmaker -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -A FORWARD -i wlan0 -o netmaker -j ACCEPT
      '';
      extraStopCommands = ''
        iptables -D FORWARD -i netmaker -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -D FORWARD -i wlan0 -o netmaker -j ACCEPT
      '';
    };
    nat = {
      enable = true;
      internalIPs = [ "10.101.0.0/16" ];
      externalInterface = "netmaker";
    };
    # Enabling WIFI

    wireless.enable = true;
    wireless.interfaces = [ "wlan0" ];
    # If you want to connect also via WIFI to your router
    # TODO maybe now leak
    wireless.networks."MartinRouterKing".psk = "natoneprijdes";

    # interfaces.wlan0.ipv4.addresses = [{
    #   address = "10.1.1.231";
    #   prefixLength = 24;
    # }];
  };

  roles = {
    netclient.enable = true;
    tailscale = {
      enable = true;
    };
  };
}
