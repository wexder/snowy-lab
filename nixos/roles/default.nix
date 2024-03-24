{ config, pkgs, lib, ... }: {
  imports = [
    ./3d.nix
    ./cad.nix
    ./desktop.nix
    ./dev.nix
    ./lsp.nix
    ./dns.nix
    ./docker.nix
    ./games.nix
    ./jupyter.nix
    ./prometheus.nix
    ./tailscale.nix
    ./videoEditing.nix
    ./virtualization.nix
    ./wine.nix
    ./xMinimalDesktop.nix
    ./xMinimalDesktop.nix
  ];
}
