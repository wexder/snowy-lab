{ config, pkgs, lib, ... }:
let
  cfg = config.roles.dev;
in
{
  options.roles.dev = {
    enable = lib.mkEnableOption "Enable dev tools";
    android = lib.mkEnableOption "Enable android dev tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable
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
          glibc
        ];


        programs.direnv = {
          enable = true;
          loadInNixShell = true;
          nix-direnv = {
            enable = true;
          };
        };
      })
    (lib.mkIf cfg.android
      {
        programs.adb.enable = true;
        users.users.wexder.extraGroups = [ "adbusers" ];
      })
  ];
}
