{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}: {
  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1048576; # default:  8192
    "fs.inotify.max_user_instances" = 8192; # default:   128
    "fs.inotify.max_queued_events" = 1048576; # default: 16384
  };
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "524288";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "32768";
    }
  ];
  hardware.enableAllFirmware = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.ledger.enable = lib.mkDefault true;

  imports = [
    ./gpu/default.nix
  ];
}
