{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./gnome.nix
    ./jupyter.nix
    ./netclient.nix
    ./tailscale.nix
  ];
}
