{
  pkgs,
  lib,
  isLinux ? false,
  ...
}: {
  imports =
    [
      ./3d.nix
      ./cad.nix
      ./dev.nix
      ./dns.nix
      ./docker.nix
      ./flatpak.nix
      ./games.nix
      ./jupyter.nix
      ./laptop.nix
      ./mcc.nix
      ./officeWg.nix
      ./prometheus.nix
      ./twingate.nix
      ./videoEditing.nix
      ./virtualization.nix
      ./wine.nix
      ./wireshark.nix
    ]
    ++ lib.optionals isLinux [
      ./desktop.nix
      ./xMinimalDesktop.nix
    ];
}
