{ lib, config, pkgs, modulesPath, ... }:
{
  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 524288; # default:  8192
    "fs.inotify.max_user_instances" = 2048; # default:   128
    "fs.inotify.max_queued_events" = 65536; # default: 16384
  };
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  imports = [
    ./gpu/default.nix
  ];
}
