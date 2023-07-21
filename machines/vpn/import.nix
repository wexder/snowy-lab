{ pkgs, modulesPath, lib, ... }:
let
  flakeClone = pkgs.writeText "flake.nix" (builtins.readFile ./../../flake.nix);
  defaultClone = pkgs.writeText "default.nix" (builtins.readFile ./default.nix);

  baseClone = pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, ... }:

      {
          imports = [];
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
    '';
in
{
  boot.postBootCommands =
    ''
      # Provide a mount point for nixos-install.
      mkdir -p /mnt
      mkdir -p /etc/nixos/machines/vpn

        # Provide a configuration for the CD/DVD itself, to allow users
        # to run nixos-rebuild to change the configuration of the
        # running system on the CD/DVD.
        if ! [ -e /etc/nixos/configuration.nix ]; then
          cp ${baseClone} /etc/nixos/configuration.nix
        fi
        if ! [ -e /etc/nixos/machines/vpn/default.nix ]; then
          cp ${defaultClone} /etc/nixos/machines/vpn/default.nix
        fi
        if ! [ -e /etc/nixos/flake.nix ]; then
          cp ${flakeClone} /etc/nixos/flake.nix
        fi
    '';
}
