{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dbeaver-bin
    # pkgs.postman
    # pkgs.caprine-bin
    # pkgs.redisinsight
    # pkgs.notion-app-enhanced
    # notion
    pkgs.bitwarden-desktop
    pkgs.vlc
    pkgs.kooha
    pkgs.tigervnc
    pkgs.voxtype
  ];

  # services.blueman-applet.enable = true;
}
