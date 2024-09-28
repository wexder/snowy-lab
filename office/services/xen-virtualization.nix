# Common configuration for Xen DomU NixOS virtual machines.
{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.virtualisation.xen;
in

{
  ## Interface ##
  options.virtualisation.xen.guest = {
    enable = lib.options.mkEnableOption "the Xen Guest Agent daemon, for easier XenStore access inside unprivileged domains";
    package = lib.options.mkPackageOption pkgs "Xen Guest Agent" { default = "xen-guest-agent"; };
    recommendedPVSettings = lib.options.mkEnableOption "the recommended settings for Xen PV/PVH guests. Disabling both `recommendedPVSettings` and `recommendedHVMSettings` will only enable the Xen Guest Agent service.";
    recommendedHVMSettings = lib.options.mkEnableOption "the recommended settings for Xen HVM guests. Disabling both `recommendedPVSettings` and `recommendedHVMSettings` will only enable the Xen Guest Agent service.";
  };

  ## Implementation ##
  config = lib.modules.mkIf cfg.guest.enable {
    assertions = [
      {
        assertion = !cfg.enable;
        message = "The Xen domU module cannot be enabled in a Xen dom0.";
      }
      {
        assertion = cfg.guest.recommendedPVSettings -> !cfg.guest.recommendedHVMSettings;
        message = "A Xen VM cannot simultaneously be a PV and an HVM domain! Set only one (or neither) of virtualisation.xen.guest.recommended*Settings.";
      }
      {
        assertion = !config.services.xe-guest-utilities.enable;
        message = "The XenServer guest utilities cannot be enabled alongside the Xen Guest Agent.";
      }
    ];

    environment.systemPackages = [ cfg.guest.package ];

    systemd = {
      packages = [ cfg.guest.package ];
      services.xen-guest-agent.wantedBy = [ "multi-user.target" ];
    };

    boot = lib.modules.mkIf (cfg.guest.recommendedPVSettings || cfg.guest.recommendedHVMSettings) {

      # PV/PVH guests don't need a kernel or initrd, as they're provided by Xen.
      #TODO: This doesn't make any sense! Why are we loading modules to a kernel that doesn't exist?
      kernel.enable = !cfg.guest.recommendedPVSettings;
      initrd = {
        enable = !cfg.guest.recommendedPVSettings;

        # Load guest-specific Xen kernel modules.
        kernelModules = [
          "xen_blkfront"
          "xen_tpmfront"
          "xen_kbdfront"
          "xen_fbfront"
          "xen_netfront"
          "xen_pcifront"
          "xen_scsifront"
          # "xen_balloon"
          "xen_hcd"
        ];
      };
      kernelModules = [
        "9pnet_xen"
        "xen_wdt"
        "drm_xen_front"
        "snd_xen_front"
        "xenfs"
      ];

      # PV/PVH guests are booted by the hypervisor, so we don't need a bootloader.
      loader.grub.device = lib.strings.optionalString cfg.guest.recommendedPVSettings "nodev";
    };

    services = lib.modules.mkIf (cfg.guest.recommendedPVSettings || cfg.guest.recommendedHVMSettings) {
      # Send syslog messages to the Xen console.
      syslogd.tty = "hvc0";
      # Don't run ntpd, since we should get the correct time from Dom0.
      timesyncd.enable = false;
    };
  };
  meta.maintainers = with lib.maintainers; [ sigmasquadron ];
}
