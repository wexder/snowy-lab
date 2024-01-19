{ config, pkgs, lib, ... }:
let
  cfg = config.roles.virtualisation;
in
{
  options.roles.virtualisation = {
    enable = lib.mkEnableOption "Enable virtualisation";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = [
        pkgs.qemu
        pkgs.quickemu
      ];

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };

      users.extraGroups.libvirtd.members = [ "wexder" ];
    };
}
