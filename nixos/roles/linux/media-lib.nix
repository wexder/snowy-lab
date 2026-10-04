{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.media-lib;
in
{
  options.roles.media-lib = {
    enable = lib.mkEnableOption "Enable media library mounts";
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/media/movies" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/movies";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };

    fileSystems."/media/shows" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/shows";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };

    fileSystems."/media/books" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/ebooks";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
