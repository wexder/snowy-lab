# Common config shared among all machines
{ config, pkgs, hostName, lib, ... }: {
  system.stateVersion = "24.05";

  imports = [ ./roles ];
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

  environment.systemPackages = [
    pkgs.iwd
    pkgs.git
    pkgs.tmux
    pkgs.tmux-sessionizer
    pkgs.htop
    pkgs.jq
    pkgs.neovim-unwrapped
    pkgs.tree
    pkgs.wget
    pkgs.curl
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.gcc
    pkgs.unzip
    pkgs.ripgrep
    pkgs.fwupd
    pkgs.pciutils
    pkgs.nfs-utils
    pkgs.age
    pkgs.ssh-to-age
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # TODO 
  # services.getty.helpLine =
  #   ">>> Flake node: ${hostName}, environment: ${environment}";

  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };


  time.timeZone = "Europe/Prague";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9"
  ];

  security.polkit.enable = true;

  users.mutableUsers = false;
  users.users.wexder = {
    isNormalUser = true;
    home = "/home/wexder";
    description = "wexder";
    extraGroups = [ "wheel" ];
    hashedPasswordFile = lib.mkDefault "/etc/passwordFile-wexder";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9"
    ];
  };
  environment.shells = with pkgs; [ zsh ];
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
      tailscale.file = ./secrets/tailscale.age;
      netclient.file = ./secrets/netclient.age;
      transmissionWgPk.file = ./secrets/transmission_wg_pk.age;
      transmissionWgPub.file = ./secrets/transmission_wg_pub.age;
      mccVPN.file = ./secrets/mcc_openvpn.age;
      mccVPNAuth.file = ./secrets/mcc_openvpn_auth.age;
      polarFoxCgWgPk.file = ./secrets/polar_fox_cg_wg_pk.age;
      snowballWgPk.file = ./secrets/snowball_cg_wg_pk.age;
      walrusWgPk = {
          file = ./secrets/walrus_cg_wg_pk.age;
      };
    };

    # TODO replace with more generic path
    identityPaths = [
        "/home/wexder/.ssh/age"
        "/etc/nixos/age"
        "/persist/age"
    ];
  };

  services.openvpn.servers = {
    mccVPN = {
      config = ''
        config ${config.age.secrets.mccVPN.path}
        auth-user-pass ${config.age.secrets.mccVPNAuth.path}
      '';
    };
  };

  # Dev hosts
  networking.extraHosts =
    ''
      127.0.0.1 local-k8s.local
      127.0.0.1 minio
    '';

  security.pki.certificateFiles = [
    ./secrets/ca.pem
  ];


  # environment.etc."issue.d/ip.issue".text = ''
  #   IPv4: \4
  # '';
  # networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

}
