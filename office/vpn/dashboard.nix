{ lib, pkgs, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    settings = {
      title = "Snowy lab";
      background = "https://wallpapercave.com/wp/wp12329536.png";
      cardBlur = "md";
      theme = "dark";
      color = "slate";
      hideVersion = true;
      quicklaunch = {
        provider = "custom";
        url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=";
        target = "_blank";
      };
    };
    services = [
      {
        "Remote" = [
          {
            "pikvm" = {
              href = "https://kvm.office.local-k8s.tech";
              description = "Workstation kvm";
              icon = "pikvm-light.png";
            };
          }
        ];
      }
      {
        "Storage" = [
          {
            "nas" =
              {
                href = "https://nas.office.local-k8s.tech";
                description = "Truenas";
                icon = "truenas-scale.png";
              };
          }
        ];
      }
      {
        "Home" = [
          {
            "home-assistant" =
              {
                href = "https://home.office.local-k8s.tech";
                description = "Home Assistant";
                icon = "home-assistant.png";
              };
          }
        ];
      }
      {
        "Virtualization" = [
          {
            "xao" = {
              href = "https://xao.office.local-k8s.tech";
              description = "Xen orchestra";
              icon = "xen-orchestra.png";
            };
          }
          {
            "mother" = {
              href = "https://192.168.240.42";
              description = "Xcp mother";
              icon = "xcp-ng.png";
            };
          }
          {
            "father" = {
              href = "https://192.168.240.230";
              description = "Xcp father";
              icon = "xcp-ng.png";
            };
          }
        ];
      }
    ];
  };
}
