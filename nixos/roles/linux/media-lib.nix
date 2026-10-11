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
    # The shares show up under "Devices" in the file manager, which mounts
    # them by running `mount` as the logged-in user. That needs the `users`
    # option on each share, and NFS helpers that are setuid: mount drops its
    # own privileges before it calls them. They only mount what fstab marks as
    # user-mountable.
    security.wrappers = lib.genAttrs [ "mount.nfs" "mount.nfs4" "umount.nfs" "umount.nfs4" ] (name: {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.nfs-utils}/bin/${name}";
    });

    fileSystems."/media/movies" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/movies";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "users"
      ];
    };

    fileSystems."/media/shows" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/shows";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "users"
      ];
    };

    fileSystems."/media/books" = {
      device = "192.168.240.112:/mnt/main_pool/private/media/ebooks";
      fsType = "nfs4";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "users"
      ];
    };
  };
}
