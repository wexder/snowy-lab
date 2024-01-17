{ config, pkgs, lib, ... }: {
  imports = [
    ./cad.nix
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
    ./wine.nix
    ./xMinimalDesktop.nix
  ];
}
