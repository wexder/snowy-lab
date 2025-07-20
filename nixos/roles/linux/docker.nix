{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.roles.docker;
in
{
  options.roles.docker = {
    enable = lib.mkEnableOption "Enable docker";
  };

  config =
    lib.mkIf cfg.enable
      {
        virtualisation.docker = {
          enable = true;
          daemon = {
            settings = {
              default-network-opts = {
                bridge = {
                  "com.docker.network.enable_ipv6" = "true";
                };
              };
            };
          };
        };

        users.extraGroups.docker.members = [ "wexder" ];

        virtualisation.podman.enable = true;
        environment.systemPackages = [
          pkgs.buildah
        ];
      };
}
