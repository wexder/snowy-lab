{
  config,
  lib,
  ...
}: let
  cfg = config.roles.zerotier;
in {
  options.roles.zerotier = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config =
    lib.mkIf cfg.enable
    {
        services.zerotierone.enable = true;
    };
}
