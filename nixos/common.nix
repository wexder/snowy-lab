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
    ];
  };

  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["wexder"];

  # latest kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  time.timeZone = "Europe/Prague";
  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.tmux
    pkgs.tmux-sessionizer
    pkgs.htop
    pkgs.jq
    pkgs.neovim-unwrapped
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

  users.mutableUsers = false;
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

  # WebDAV
  #   services.davfs2.enable = true;
  #   systemd.mounts = [
  #   {
  #     enable = true;
  #     description = "Webdav mount point";
  #     after = [ "network-online.target" ];
  #     wants = [ "network-online.target" ];
  #
  #     what = "https://$fqdn/remote.php/dav/files/$myuser";
  #     where = "/mnt/nextcloud";
  #     options = uid=1000,gid=1000,file_mode=0664,dir_mode=2775
  #     type = "davfs";
  #     mountConfig.TimeoutSec = 15;
  #   }
  # ];
}
