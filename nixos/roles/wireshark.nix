{ config, pkgs, lib, ... }:
let
  cfg = config.roles.wireshark;
in
{
  options.roles.wireshark = {
    enable = lib.mkEnableOption "Enable wireshark";
  };

  config = lib.mkIf cfg.enable
    {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };

      users.groups.wireshark = { };
      users.extraGroups.wireshark.members = [ "wexder" ];
    };
}
