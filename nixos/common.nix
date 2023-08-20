# Common config shared among all machines
{ config, pkgs, hostName, environment, lib, catalog, ... }: {
  system.stateVersion = "23.05";

  imports = [ ./roles ];
  nixpkgs.config.allowUnfree = true;

  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  networking.hostName = hostName;

  environment.systemPackages = with pkgs;[
    git
    tmux
    htop
    jq
    neovim
    tree
    vim-is-neovim
    wget
  ];

  # TODO 
  # services.getty.helpLine =
  #   ">>> Flake node: ${hostName}, environment: ${environment}";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  time.timeZone = "Europe/Prague";

  users.users.root.openssh.authorizedKeys.keys =
    # TODO
    lib.splitString "\n" (builtins.readFile ../authorized_keys.txt);

  users.users.wexder = {
    uid = 1001;
    isNormalUser = true;
    home = "/home/wexder";
    description = "wexder";
    extraGroups = [ "docker" "wheel" ];
    openssh.authorizedKeys.keys =
      # TODO
      lib.splitString "\n" (builtins.readFile ../authorized_keys.txt);
  };

  # age.secrets = {
  #   influxdb-telegraf.file = ./secrets/influxdb-telegraf.age;
  #   tailscale.file = ./secrets/tailscale.age;
  # };

  # environment.etc."issue.d/ip.issue".text = ''
  #   IPv4: \4
  # '';
  # networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";
}
