{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./games.nix
    ./jupyter.nix
    ./netclient.nix
    ./prometheus.nix
    ./tailscale.nix
    ./videoEditing.nix
    ./xMinimalDesktop.nix
  ];
}
