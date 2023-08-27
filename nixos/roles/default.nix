{ config, pkgs, lib, ... }: {
  imports = [
    ./dns.nix
    ./docker.nix
    ./dev.nix
  ];
}
