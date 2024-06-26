{ config, pkgs, lib, zls, zig, ... }:
let
  cfg = config.roles.lsp;
  gow = pkgs.callPackage ../../apps/gow.nix { };
in
{
  options.roles.lsp = {
    go = lib.mkEnableOption "go language";
    rust = lib.mkEnableOption "rust language";
    zig = lib.mkEnableOption "zig language";
    cpp = lib.mkEnableOption "cpp language";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.go {
      environment.systemPackages = [
        gow
        pkgs.gopls
        pkgs.gotests
        pkgs.gosec
        pkgs.golangci-lint
        pkgs.golangci-lint-langserver
        pkgs.gotools
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

    (lib.mkIf cfg.cpp {
      environment.systemPackages = [
        pkgs.clang-tools
        pkgs.bear
      ];
    })
  ];
}
