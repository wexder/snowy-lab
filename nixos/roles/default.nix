{ config, pkgs, lib, ... }: {
  imports = [
    ./cad.nix
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./games.nix
    ./jupyter.nix
    ./netmaker/default.nix
    ./prometheus.nix
    ./tailscale.nix
    ./videoEditing.nix
    ./virtualization.nix
    ./wine.nix
    ./xMinimalDesktop.nix
    ./xMinimalDesktop.nix
  ];
}
