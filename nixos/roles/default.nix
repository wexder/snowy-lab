{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./jupyter.nix
    ./netclient.nix
    ./prometheus.nix
    ./tailscale.nix
    ./xMinimalDesktop.nix
  ];
}
