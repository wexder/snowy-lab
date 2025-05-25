{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.dev;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable
      {
        environment.systemPackages = with pkgs; [
          bash
          doctl
          postgresql
          kubectl
          nil
          go
          rustup
          cachix
          gnumake
          glibc
        ];
      })
    (lib.mkIf cfg.android
      {
        programs.adb.enable = true;
        users.users.wexder.extraGroups = ["adbusers" "plugdev"];
        users.groups.plugdev = {};
      })
  ];
}
