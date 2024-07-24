{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.dbeaver-bin
    pkgs.postman
    pkgs.caprine-bin
    pkgs.resp-app
    pkgs.notion-app-enhanced
    pkgs.chromium
    pkgs.bitwarden
    pkgs.bitwarden-cli
    pkgs.vlc
    pkgs.kooha
    pkgs.tigervnc

    pkgs.obsidian # testing
    # pkgs.appflowy # testing
    # pkgs.floorp # testing
    pkgs.scrcpy # testing, android screen mirror
    pkgs.birdtray # testing
    pkgs.qflipper # testing
    pkgs.signal-desktop # testing
  ];

  services.blueman-applet.enable = true;
}
