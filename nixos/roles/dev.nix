{ config, pkgs, lib, ... }:
let
  cfg = config.roles.dev;
in
{
  options.roles.dev = {
    enable = lib.mkEnableOption "Enable dev tools";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs;[
        bash
        doctl
        postgresql
        kubectl
        nil
        rustup
        go
        rustc
        nodejs_20
        cachix
        gnumake
      ];


      programs.direnv = {
        enable = true;
        loadInNixShell = true;
        nix-direnv = {
          enable = true;
        };
      };
    };
}
