{ config, pkgs, lib, ... }: {
  imports = [
    ./3d.nix
    ./cad.nix
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./games.nix
    ./jupyter.nix
    ./lsp.nix
    ./netbird.nix
    ./officeWg.nix
    ./prometheus.nix
    ./tailscale.nix
    ./twingate.nix
    ./videoEditing.nix
    ./virtualization.nix
    ./wine.nix
    ./xMinimalDesktop.nix
    ./xMinimalDesktop.nix
  ./laptop.nix
  ];
}
