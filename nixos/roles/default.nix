{ config, pkgs, lib, ... }: {
  imports = [
    ./dns.nix
    ./docker.nix
    ./dev.nix
    ./netclient.nix
    ./desktop.nix
  ];
}
