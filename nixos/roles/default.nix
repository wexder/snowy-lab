{ config, pkgs, lib, ... }: {
  imports = [
    ./amd.nix
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./netclient.nix
  ];
}
