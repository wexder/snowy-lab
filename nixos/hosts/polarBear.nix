{
  config,
  pkgs,
  ...
}: {
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
        pixel = {
          id = "VYI5BP3-NBVRZX4-JGWGRFA-O42HSBU-FBVDOAK-EZU5Z7N-HBYQZQK-24HU4AO";
        };
        snowflake = {
          id = "HEYQRXA-NJNSJXA-UYLL2DQ-V7CJ5JP-NP534AD-BH7R4W2-MELM7CF-XLMEZAY";
        };
        snowball = {
          id = "ZH4HMPO-LTPXSUA-EBRLTNJ-KWDM6F7-KVSJUCW-KPMDJAJ-DJWJ2VF-HBQNOQQ";
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
      enable = false;
    };
    games = {
      enable = true;
      server = true;
    };
    prometheus = {
      enable = true;
      nut = true;
    };
    virtualisation = {
      enable = true;
    };
    mccDev = {
      enable = true;
      use_netbird = false;
    };
    zerotier = {
      enable = true;
    };
    wyoming = {
      enable = false;
    };
  };
}
