{ config, pkgs, lib, ... }:
let
  cfg = config.roles.docker;
in
{
  options.roles.docker = {
    enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf cfg.enable
    {
      virtualisation.libvirtd.enable = true;
      virtualisation.docker.enable = true;
      users.extraGroups.docker.members = [ "wexder" ];
    };
}
