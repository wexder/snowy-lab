{ pkgs
, config
, ...
}:
let
  caddy = pkgs.callPackage ./caddy { };
  hostnames = (import ./hostnames.nix { }).caddy.office;
  virtualHosts = builtins.mapAttrs
    (k: { port, ip }: {
      extraConfig = ''
        encode gzip
        reverse_proxy ${ip}:${builtins.toString port}
        tls {
            load /var/lib/acme/office.local-k8s.tech/full.pem /var/lib/acme/.office.local-k8s.tech/full.pem
        }
        log {
          	output stdout
            format console
        }
      '';
    })
    hostnames;
in
{
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "vladimir.zahradnik@codegrowers.tech";
    certs = {
      ".office.local-k8s.tech" = {
        domain = "*.office.local-k8s.tech";
        dnsProvider = "digitalocean";
        environmentFile = config.age.secrets.oudaddy.path;
        group = "caddy";
      };
      "office.local-k8s.tech" = {
        domain = "office.local-k8s.tech";
        dnsProvider = "digitalocean";
        environmentFile = config.age.secrets.oudaddy.path;
        group = "caddy";
      };
    };
  };

  services.caddy = {
    package = caddy;
    enable = true;
    virtualHosts = virtualHosts // { };
    environmentFile = config.age.secrets.oudaddy.path;

    globalConfig = ''
    '';
  };

  systemd.services.caddy.serviceConfig = {
    # Bind standard privileged ports
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
  };

}
