{
  config,
  lib,
  ...
}: let
  cfg = config.roles.officeWg;
in {
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [51820];

    boot.supportedFilesystems = ["nfs"];
    services.rpcbind.enable = true; # needed for NFS

    systemd.mounts = let
      commonMountOptions = {
        type = "nfs";
        mountConfig = {
          Options = "noatime";
        };
      };
    in [
      (
        commonMountOptions
        // {
          what = "192.168.240.111:/mnt/main_pool/private/media/ebooks/";
          where = "/mnt/nas/ebooks";
        }
      )

      (
        commonMountOptions
        // {
          what = "192.168.240.111:/mnt/main_pool/private/media/movies/";
          where = "/mnt/nas/movies";
        }
      )
      (
        commonMountOptions
        // {
          what = "192.168.240.111:/mnt/main_pool/private/media/shows/";
          where = "/mnt/nas/shows";
        }
      )
      (
        commonMountOptions
        // {
          what = "192.168.240.111:/mnt/main_pool/private/media/travel_videos/";
          where = "/mnt/nas/travel_videos";
        }
      )
    ];

    systemd.automounts = let
      commonAutoMountOptions = {
        wantedBy = ["multi-user.target"];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
      };
    in [
      (commonAutoMountOptions // {where = "/mnt/nas/ebooks";})
      (commonAutoMountOptions // {where = "/mnt/nas/movies";})
      (commonAutoMountOptions // {where = "/mnt/nas/shows";})
      (commonAutoMountOptions // {where = "/mnt/nas/travel_videos";})
    ];
  };
}
