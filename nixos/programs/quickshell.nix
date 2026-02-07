{
  config,
  lib,
  pkgs,
  quickshell_pkg,
  ...
}:
let
  cfg = lib.fileset.toSource {
    root = ./quickshell;
    fileset = ./quickshell;
  };
in
{
  programs.quickshell = {
    enable = true;
    package = quickshell_pkg.overrideAttrs (old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ pkgs.kdePackages.qt5compat ]);
    });
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    activeConfig = "${cfg}";
  };
}
