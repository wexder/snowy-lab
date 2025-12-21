{
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "polar-bear";
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

  # Needed for tmux
  environment.systemPackages = [
    pkgs.ghostty
  ];

  services.syncthing = {
    enable = true;
    user = "wexder";
    dataDir = "/home/wexder/.config/syncthing";
    settings = {
      folders = {
        "thunderbird" = {
          id = "thunderbird";
          path = "/home/wexder/.thunderbird/";
          devices = [
            "polar-fox"
            "walrus"
            "snowflake"
            "snowball"
          ];
        };
        "documents" = {
          id = "documents";
          path = "/home/wexder/documents/";
          devices = [
            "polar-fox"
            "walrus"
            "snowflake"
            "snowball"
          ];
        };
        "obsidian" = {
          id = "obsidian";
          path = "/home/wexder/obsidian/";
          devices = [
            "polar-fox"
            "walrus"
            "pixel"
            "snowflake"
            "snowball"
          ];
        };
      };
      devices = {
        polar-fox = {
          id = "ZPGM2C2-7HU64BM-DUWFVEZ-FICHF25-D7MUVZ2-AXXKIXQ-EDN7XSQ-JVO5OQS";
        };
        walrus = {
          id = "ZPVTWIR-CJTCRIV-Q7AAP7C-UGIRTRZ-QDRRMBO-U6CJUIV-UEAAPHR-AQWUXQG";
        };
        snowflake = {
          id = "HEYQRXA-NJNSJXA-UYLL2DQ-V7CJ5JP-NP534AD-BH7R4W2-MELM7CF-XLMEZAY";
        };
        snowball = {
          id = "ZH4HMPO-LTPXSUA-EBRLTNJ-KWDM6F7-KVSJUCW-KPMDJAJ-DJWJ2VF-HBQNOQQ";
        };
        pixel = {
          id = "AQUF75E-QT4IREH-MKOAKPM-YA4O24V-FKOKGF7-YJPP3KO-GBDVL2X-AY25OAN";
        };
      };
    };
  };

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    xMinimalDesktop = {
      enable = true;
    };
    twingate = {
      enable = true;
    };
    jupyter = {
      enable = false;
    };
    llm = {
      enable = true;
    };
    games = {
      enable = true;
      server = true;
    };
    prometheus = {
      enable = false;
      nut = false;
    };
    virtualisation = {
      enable = true;
    };
    mccDev = {
      enable = true;
      use_netbird = true;
    };
    zerotier = {
      enable = true;
    };
    wyoming = {
      enable = false;
    };
  };
}
