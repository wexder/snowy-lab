{ config, pkgs, lib, ... }: {
  imports = [
    ./amd.nix
    ./nvidia.nix
  ];
}
