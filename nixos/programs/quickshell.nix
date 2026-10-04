{
  config,
  lib,
  pkgs,
  quickshell_pkg,
  ...
}:
let
  cfg = config.roles.quickshell;

  # The QML tree plus the nix-generated settings, assembled into a single
  # read-only source directory that quickshell is pointed at.
  settings = pkgs.writeText "quickshell-generated.json" (builtins.toJSON {
    colors = cfg.colors;
    font = cfg.font;
    bar = cfg.bar;
    behaviour = cfg.behaviour;
  });

  source = pkgs.runCommand "quickshell-config" { } ''
    cp -r ${
      lib.fileset.toSource {
        root = ./quickshell;
        fileset = ./quickshell;
      }
    } $out
    chmod -R u+w $out
    cp ${settings} $out/config/generated.json
  '';
  # `qs ipc` needs to be told which config it is talking to, and that path is
  # a store path — so wrap it once here rather than repeating it in keybinds.
  qsPackage = quickshell_pkg.overrideAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ pkgs.kdePackages.qt5compat ]);
  });

  qsIpc = pkgs.writeShellScriptBin "qs-ipc" ''
    exec ${qsPackage}/bin/qs -p ${source} ipc "$@"
  '';
in
{
  options.roles.quickshell = {
    enable = lib.mkEnableOption "the quickshell desktop shell" // {
      default = true;
    };

    colors = lib.mkOption {
      description = "Colour tokens handed to the shell. Defaults to a red theme.";
      type = lib.types.attrsOf lib.types.str;
      default = {
        # Neutrals — warm charcoal, faintly red-tinted.
        base = "#191316";
        mantle = "#130E11";
        surface = "#241C20";
        surfaceAlt = "#33272C";
        overlay = "#4C3B42";

        # Foreground
        text = "#F3E9EB";
        subtext = "#DCCBCF";
        muted = "#9C858C";

        # Brand. onPrimary is whatever is legible on top of primary — with a
        # dark red that has to be near-white, so it is its own token rather
        # than being derived from the background.
        primary = "#C2354A";
        secondary = "#E8697A";
        onPrimary = "#FFF1F3";

        # Semantic. error is a brighter, warmer red than primary so alerts
        # stay distinguishable from brand colour.
        success = "#6FAF7A";
        warning = "#E9A13B";
        error = "#FF6B5B";
      };
    };

    font = lib.mkOption {
      description = "Font families and base size for the shell.";
      type = lib.types.attrsOf (lib.types.either lib.types.str lib.types.int);
      default = {
        family = "FiraCode Nerd Font";
        mono = "FiraCode Nerd Font Mono";
        symbols = "Symbols Nerd Font Mono";
        size = 12;
      };
    };

    bar = lib.mkOption {
      description = "Bar geometry and behaviour.";
      type = lib.types.attrsOf lib.types.anything;
      default = {
        height = 34;
        onTop = true;
        opacity = 0.85;
        maxTitleLength = 90;
        # Tray items to hide, matched on their id. blueman-applet stays running
        # for its pairing agent and notifications, but its tray icon duplicates
        # the shell's own bluetooth widget.
        trayBlacklist = [ "blueman" ];
      };
    };

    behaviour = lib.mkOption {
      description = "Timeouts and the helper applications the shell hands off to.";
      type = lib.types.attrsOf lib.types.anything;
      default = {
        # Popups use this timeout regardless of what the sending app requests,
        # matching what mako's ignore-timeout did.
        notificationTimeout = 5000;
        ignoreAppTimeout = true;
        maxNotificationTimeout = 15000;
        # Prompts that ask a question stay up until answered rather than
        # expiring unanswered. A prompt is one that carries actions the user
        # can answer *and* whose sender asked for no expiry (timeout 0) —
        # bluetooth pairing does both. Chat apps attach actions to routine
        # messages, so actions alone would pin every Slack message forever.
        persistActionable = true;
        maxPopups = 4;
        osdTimeout = 1500;
        terminal = "ghostty";
        audioMixer = "pavucontrol";
        networkEditor = "nm-connection-editor";
        bluetoothManager = "blueman-manager";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      package = qsPackage;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      activeConfig = "${source}";
    };

    # The shell needs these for the pieces it hands off to, and brightnessctl
    # for the backlight OSD.
    home.packages = [
      qsIpc
      pkgs.brightnessctl
      pkgs.networkmanagerapplet
      pkgs.libnotify
    ];
  };
}
