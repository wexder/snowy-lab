{
  config,
  pkgs,
  ...
}: let
  proxmark3 = pkgs.proxmark3.override {
    withGeneric = true;
  };
in {
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "walrus";
    firewall = {
      enable = false;
    };

    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  environment.systemPackages = [
    proxmark3
    pkgs.intel-undervolt
    pkgs.openfortivpn
  ];

  users.users.wexder.password = "test";
  users.users.wexder.hashedPasswordFile = null;
  users.users.wexder.extraGroups = [
    "dialout"
    "bluetooth"
  ];

  hardware.flipperzero.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;

  networking.wg-quick.interfaces = {
    connectTest = {
      address = [
        "fda6:485c:ba29:2dd8::2"
      ];
      listenPort = 51821;
      peers = [
        {
          allowedIPs = [
            "fda6:485c:ba29:2dd8::/64"
          ];
          endpoint = "109.123.221.201:52820";
          publicKey = "1e24LrILrIZab43+rLqpIPWCyoXyMwLKaWVB0YYyFA4=";
        }
      ];
      privateKey = "WKiQS2CnQvadyHPhXB/JLCIyzzbkMQyXJ21iTR+RMUE=";
    };
  };

  roles = {
    laptop = {
      enable = true;
    };
    cad = {
      enable = false;
    };
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    twingate = {
      enable = false;
    };
    desktop = {
      enable = true;
      syncthing = true;
    };
    mccDev = {
      enable = true;
      use_netbird = true;
    };
    "3d" = {
      enable = true;
    };
    officeWg = {
      enable = true;
      address = "192.168.250.5/32";
      privateKeyFile = config.age.secrets.walrusWgPk.path;
    };
    virtualisation = {
      enable = true;
    };
    wine = {
      enable = true;
    };
    work = {
      enable = true;
    };
    flatpak = {
      enable = true;
    };
    mullvad = {
      enable = true;
    };
    zerotier = {
      enable = true;
    };
  };
}
