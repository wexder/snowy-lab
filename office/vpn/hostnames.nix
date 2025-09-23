{}:
{
  dns = {
    vpn = {
      "polar-fox" = "192.168.250.2";
      "snowball " = "192.168.250.3";
      "pixel" = "192.168.250.4";
      "walrus" = "192.168.250.5";
    };
    office = {
      "@" = "192.168.240.250";
      "nas" = "192.168.240.250";
      "xao" = "192.168.240.250";
      "kvm" = "192.168.240.250";
      "home" = "192.168.240.250";
      "vpn1" = "192.168.240.193";
      "vpn2" = "192.168.240.178";
      "k8s-master" = "192.168.240.10";
      "k8s" = "192.168.240.25";
      "xcp-ng-father" = "192.168.240.230";
      "xcp-ng-mother" = "192.168.240.42";
      "nextcloud" = "192.168.240.19";
    };
  };
  caddy = {
    office = {
      "kvm.office.local-k8s.tech" = {
        port = 80;
        ip = "192.168.240.132";
      };
      "nas.office.local-k8s.tech" = {
        port = 80;
        ip = "192.168.240.111";
      };
      "xao.office.local-k8s.tech" = {
        port = 80;
        ip = "192.168.240.107";
      };
      "home.office.local-k8s.tech" = {
        port = 8123;
        ip = "192.168.69.200";
      };
      "office.local-k8s.tech" = {
        port = 8082;
        ip = "localhost";
      };
    };
  };
}
