{ config, pkgs, lib, zls, zig, ... }:
let
  cfg = config.roles.lsp;
in
{
  options.roles.lsp = {
    go = lib.mkEnableOption "go language";
    rust = lib.mkEnableOption "rust language";
    zig = lib.mkEnableOption "zig language";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.go {
      environment.systemPackages = [
        pkgs.gopls
        pkgs.gotests
        pkgs.gosec
      ];
    })

    (lib.mkIf cfg.rust {
      environment.systemPackages = [
        pkgs.cargo-watch
        pkgs.rust-analyzer
        pkgs.pkg-config
        pkgs.openssl
      ];
    })

    (lib.mkIf cfg.zig {
      environment.systemPackages = [
        zls.zls
        zig.master
      ];
    })
  ];
}
