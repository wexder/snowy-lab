{ config, lib, pkgs, ... }:
let
  postman = pkgs.postman.overrideAttrs (oldAttrs: rec {
    version = "20230716100528";
    src = pkgs.fetchurl {
      url = "https://web.archive.org/web/${version}/https://dl.pstmn.io/download/latest/linux_64";
      sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

      name = "${oldAttrs.pname}-${version}.tar.gz";
    };
  });
in
{
  home.packages = [
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.dbeaver
    postman
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
