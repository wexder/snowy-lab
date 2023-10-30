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
      ];
    };
}
