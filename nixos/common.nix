# Common config shared among all machines
{
  pkgs,
  hostName,
  lib,
  ...
}: {
  system.stateVersion = "24.05";

  imports = [./roles];
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-39.8.10"
    ];
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    # Garbage collect & optimize /nix/store daily.
    optimise.automatic = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "wexder" ];
      substituters = [
        "https://nix-community.cachix.org?priority=1"
        "https://numtide.cachix.org?priority=2"
        "https://cache.nixos.org?priority=3"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };
  nix.optimise.automatic = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = ["wexder"];
  programs.nix-ld.enable = true;

  # latest kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  time.timeZone = "Europe/Prague";
  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.tmux
    pkgs.tmux-sessionizer
    pkgs.htop
    pkgs.jq
    pkgs.neovim-unwrapped
    pkgs.tree-sitter
    pkgs.wget
    pkgs.curl
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.unzip
    pkgs.ripgrep
    pkgs.fwupd
    pkgs.nfs-utils
    pkgs.age
    pkgs.ssh-to-age
    pkgs.nushell
    pkgs.zig # CC compiler
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  security.polkit = {
    enable = true;
  };

  users.mutableUsers = true; # TODO find better solution
  users.users.wexder = {
    isNormalUser = true;
    home = "/home/wexder";
    description = "wexder";
    extraGroups = ["wheel"];
    hashedPasswordFile = lib.mkDefault "/etc/passwordFile-wexder";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9"
    ];
  };

  environment.shells = with pkgs; [zsh];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  systemd.oomd.enable = true;

  # disk automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;

  age = {
    secrets = {
      transmissionWgPk.file = ./secrets/transmission_wg_pk.age;
      transmissionWgPub.file = ./secrets/transmission_wg_pub.age;
      polarFoxCgWgPk.file = ./secrets/polar_fox_cg_wg_pk.age;
      snowballWgPk.file = ./secrets/snowball_cg_wg_pk.age;
      walrusWgPk = {
        file = ./secrets/walrus_cg_wg_pk.age;
      };
    };

    identityPaths = [
      "/home/wexder/.ssh/age"
    ];
  };

  # Mandatory
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "all"
  ];
}
