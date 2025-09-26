{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dbeaver-bin
    # pkgs.postman
    pkgs.caprine-bin
    pkgs.resp-app
    # pkgs.notion-app-enhanced
    # notion
    pkgs.bitwarden
    pkgs.vlc
    pkgs.kooha
    pkgs.tigervnc
  ];

  # services.blueman-applet.enable = true;
}
