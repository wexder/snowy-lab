# Quickshell config

The desktop shell for Hyprland: bar, launcher, control centre, notification
centre and OSDs. Built on [quickshell](https://quickshell.org).

## Layout

| Directory     | What lives there                                                        |
|---------------|-------------------------------------------------------------------------|
| `config/`     | `Config` (settings, fed by nix) and `Theme` (semantic design tokens)     |
| `services/`   | Singletons wrapping system state — audio, battery, network, media, …     |
| `components/` | Reusable UI primitives — styled text, buttons, tooltips, overlay panels  |
| `modules/`    | The actual surfaces — bar, launcher, control centre, notifications, OSD  |

Files are imported as QML modules by directory: `import qs.services`,
`import qs.components`, `import qs.modules.bar`. Singletons are discovered
automatically, so there are no `qmldir` files to maintain.

Widgets never read `Config` directly — they read `Theme`, so a palette change
never means touching a widget.

## Configuration

Everything tunable is a nix option under `roles.quickshell`, rendered to
`config/generated.json` at build time and read by `Config` at startup:

```nix
roles.quickshell = {
  colors.primary = "#C2354A";
  # Foreground for anything drawn on top of `primary`. Set it to suit the
  # accent — deriving it from the background only works for light accents.
  colors.onPrimary = "#FFF1F3";
  font.size = 12;
  bar.height = 34;
  bar.trayBlacklist = [ "blueman" ];
};
```

This is a **home-manager** module, so it is configured in `nixos/home/<host>.nix`
alongside `roles.desktop` — not in `nixos/hosts/<host>.nix` with the
system-level roles, where the option does not exist.

### Notification behaviour

| Option | Default | Effect |
|---|---|---|
| `behaviour.notificationTimeout` | `5000` | How long a popup stays on screen |
| `behaviour.ignoreAppTimeout` | `true` | Use that timeout regardless of what the app asks for, the way mako's `ignore-timeout` did |
| `behaviour.maxNotificationTimeout` | `15000` | Ceiling when app timeouts *are* honoured |
| `behaviour.persistActionable` | `true` | Notifications carrying actions stay until answered |
| `behaviour.maxPopups` | `4` | Popups on screen at once; the overflow goes straight to the centre |

`persistActionable` is what makes bluetooth pairing confirmations work: blueman
sends them with normal urgency and action buttons, so a flat 5s timeout would
throw the prompt away before it could be answered. Critical notifications
likewise stay until dismissed.

The QML defaults in `config/Config.qml` mirror the nix defaults, so the config
also runs standalone with `qs -p .`.

## Keybinds

Bound in `../hyprland/hyprland.lua`, driven through the `qs-ipc` wrapper:

| Bind                   | Action                    |
|------------------------|---------------------------|
| `SUPER + D`            | Launcher                  |
| `SUPER + N`            | Notification centre       |
| `SUPER + I`            | Control centre            |
| Volume / brightness keys | Adjust, and show the OSD |

The same actions are available as IPC calls:

```
qs-ipc call panels toggle launcher
qs-ipc call audio raise
qs-ipc call notifications dnd
```

## Developing

```
qs -p .          # run this config alongside the installed one
qs -p . ipc show # list IPC targets
```

Quickshell hot-reloads on file changes, so edits show up without a restart.
Note that `nix build` only sees git-tracked files — `git add` new QML files
before rebuilding the system, or they will be missing from the store copy.
