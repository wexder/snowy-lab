{
  config,
  pkgs,
  lib,
  padctl,
  padctlSrc,
  ...
}:
let
  cfg = config.roles.games;

  # padctl's install command auto-generates udev rules (60-padctl.rules,
  # 61-padctl-driver-block.rules, 90-padctl.rules) by scanning its device
  # configs. We run it in staging mode (--destdir) so it only writes files
  # and does not touch the live system.
  padctlUdevRules = pkgs.runCommand "padctl-udev-rules" {
    nativeBuildInputs = [ padctl ];
  } ''
    mkdir -p $out/lib/udev/rules.d
    # Make the upstream device configs discoverable so padctl install can
    # generate per-VID/PID udev rules from them.
    ln -s ${padctlSrc}/devices devices
    ${padctl}/bin/padctl install --prefix /usr --destdir $out --no-enable --no-start --scope system
    # Move everything generated under the standard udev package path
    if [ -d $out/usr/lib/udev/rules.d ]; then
      cp -r $out/usr/lib/udev/rules.d/* $out/lib/udev/rules.d/
    fi
    if [ -d $out/etc/udev/rules.d ]; then
      cp -r $out/etc/udev/rules.d/* $out/lib/udev/rules.d/
    fi

    echo "=== Generated padctl udev rules ==="
    for f in $out/lib/udev/rules.d/*.rules; do
      echo "--- $f ---"
      cat "$f"
    done

    # Remove hotplug reconnect RUN rules — padctl handles hotplug internally
    # via netlink/udev monitor, and the reconnect script assumes a FHS layout.
    sed -i '/RUN+=.*padctl-reconnect-launch/d' $out/lib/udev/rules.d/60-padctl.rules

    # Patch absolute paths in driver-block rules for NixOS compatibility.
    for f in $out/lib/udev/rules.d/61-padctl-driver-block.rules; do
      [ -f "$f" ] || continue
      substituteInPlace "$f" \
        --replace-fail "/bin/sh" "${pkgs.bash}/bin/sh" \
        --replace-fail "/sbin/modprobe" "${pkgs.kmod}/bin/modprobe"
    done

    # Prune the rest; we only need the rules
    rm -rf $out/usr $out/etc $out/bin $out/share $out/lib/modules-load.d
  '';
in
{
  options.roles.games = {
    enable = lib.mkEnableOption "Enable games";

    server = lib.mkOption {
      default = false;
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.steam = {
          enable = true;
        };
        programs.steam.gamescopeSession = {
          enable = true;
        };

        programs.gamemode.enable = true;

        environment.sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        };

        environment.systemPackages = [
          pkgs.protonup-ng
          pkgs.mangohud
          pkgs.gamescope
          pkgs.prismlauncher
          pkgs.lutris
          pkgs.moonlight-qt
          padctl
        ];

        systemd.user.services.padctl = {
          description = "padctl gamepad compatibility daemon";
          after = [ "graphical-session.target" ];
          wantedBy = [ "default.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${padctl}/bin/padctl --config-dir %h/.local/share/padctl/devices";
            Restart = "on-failure";
            RestartSec = 3;
            StateDirectory = "padctl";
          };
        };

        services.udev.packages = [ padctlUdevRules ];

        # Explicit fallback rules for libusb-claimed devices that padctl supports.
        # The generated 60-padctl.rules should cover these, but this guarantees
        # the raw USB device node is accessible even if generation is incomplete.
        services.udev.extraRules = ''
          # Flydigi Vader 5 Pro — libusb-claimed vendor interfaces
          ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="37d7", ATTR{idProduct}=="2401", TAG+="uaccess", GROUP="input", MODE="0660"
        '';

        # Kernel modules required by padctl for virtual gamepad support.
        # (Upstream ships a modules-load.d snippet; we declare them the NixOS way.)
        boot.kernelModules = [ "uhid" "uinput" ];

        # Padctl's udev rules set GROUP="input" MODE="0660" on hidraw and
        # raw USB device nodes. Graphical sessions get uaccess ACLs automatically,
        # but devices detected before login (e.g. at boot) won't have an ACL yet.
        # Adding the user to the input group guarantees access in all cases.
        users.users.wexder.extraGroups = [ "input" ];
      }
      (lib.mkIf cfg.server {
        services.sunshine = {
          enable = true;
          capSysAdmin = true;
          autoStart = true;
        };
      })
    ]
  );
}
