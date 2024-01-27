{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.dbeaver
    # pkgs.postman
    pkgs.caprine-bin
    pkgs.resp-app
    pkgs.notion-app-enhanced
    pkgs.chromium
    pkgs.bitwarden
    pkgs.bitwarden-cli
    pkgs.vlc
    pkgs.kooha
    pkgs.tigervnc
    pkgs.obsidian
  ];

  services.blueman-applet.enable = true;
}
