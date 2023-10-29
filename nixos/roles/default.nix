{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./netclient.nix
    ./tailscale.nix
  ];
}
