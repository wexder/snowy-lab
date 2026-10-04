{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.soap;
in
{
  options.roles.soap = {
    enable = lib.mkEnableOption "Enable soap software";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.soapui.override {
        jdk = (pkgs.openjdk.override { enableJavaFX = true; });
      })
      pkgs.libxxf86vm
    ];
  };
}
