-- Hyprland Lua configuration
-- See: https://wiki.hypr.land/Configuring/Start/
--
-- `theme` is not defined here: nixos/programs/hyprland.nix prepends it, built
-- from roles.quickshell.colors so the compositor and the shell share a palette.

local mod = "SUPER"
local hy3 = hl.plugin.hy3

-- Monitor
hl.monitor({
  output = "",
  mode = "highres",
  position = "auto",
  scale = 1.33,
})

-- Environment variables
hl.env("XCURSOR_SIZE", "32")

-- General settings, decoration, misc, xwayland, input
hl.config({
    general = {
        layout = "hy3",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,

        col = {
            -- Gradients take a colours array plus an angle in degrees.
            active_border = { colors = { theme.active_border, theme.active_border2 }, angle = 45 },
            inactive_border = theme.inactive_border,
            nogroup_border = theme.nogroup_border,
            nogroup_border_active = theme.active_border,
        },
    },

    input = {
        kb_layout = "us,cz",
        kb_options = "grp:win_space_toggle",
    },

    decoration = {
        rounding = 4,

        shadow = {
            color = theme.shadow,
            color_inactive = theme.shadow_inactive,
        },
    },

    misc = {
        vrr = 3,
    },

    xwayland = {
        force_zero_scaling = true,
        use_nearest_neighbor = true,
        enabled = true,
    },

    plugin = {
        hy3 = {
            tabs = {
                height       = 5,
                padding      = 0,   -- important for stacks, see below
                border_width = 0,   -- a 2px border would swamp a 2px row
                radius       = 0,
                render_text  = false,

                colors = {
                    active                   = theme.tab_active,
                    active_border            = theme.tab_active,
                    active_text              = theme.tab_text,
                    focused                  = theme.tab_focused,
                    focused_border           = theme.tab_focused,
                    focused_text             = theme.tab_text,
                    inactive                 = theme.tab_inactive,
                    inactive_border          = theme.tab_inactive,
                    inactive_text            = theme.tab_text,
                    urgent                   = theme.tab_urgent,
                    urgent_border            = theme.tab_urgent,
                    urgent_text              = theme.tab_text,
                    locked                   = theme.tab_locked,
                    locked_border            = theme.tab_locked,
                    locked_text              = theme.tab_text,
                    active_alt_monitor        = theme.tab_alt_monitor,
                    active_alt_monitor_border = theme.tab_alt_monitor,
                    active_alt_monitor_text   = theme.tab_text,
                },
            }
        },
    },
})

-- Bezier curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

-- Animations (disabled)
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "windows", enabled = false })

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("pypr")
  hl.exec_cmd("playerctld daemon")
end)

-- Window rules
hl.window_rule({
  match = { class = ".*-float.*" },
  float = true,
})

-- Locked binds (media keys)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Volume and brightness go through the shell so its OSD reacts to them.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("qs-ipc call audio raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("qs-ipc call audio lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("qs-ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("qs-ipc call audio micMute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs-ipc call brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs-ipc call brightness lower"), { locked = true, repeating = true })

-- Non-consuming mouse bind
hl.bind("mouse:274", hl.dsp.exec_cmd("wl-copy -pc"), { non_consuming = true })

-- Application binds
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("ghostty +new-window"))
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("thunar"))
-- Shell panels. The launcher and clipboard history both replace what wofi
-- used to do on these binds.
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("qs-ipc call panels toggle launcher"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("qs-ipc call panels toggle clipboard"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("qs-ipc call panels toggle notificationCenter"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd("qs-ipc call panels toggle controlCenter"))
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | tesseract stdin stdout -l eng | wl-copy'))

-- System binds
hl.bind(mod .. " + SHIFT + X", hl.dsp.exit())
hl.bind(mod .. " + Q", hl.dsp.exec_cmd("/home/wexder/.config/hypr/murder.sh"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("panoply"))

-- hy3 group management
hl.bind(mod .. " + e", hy3.change_group("opposite"))
hl.bind(mod .. " + s", hy3.change_group("stack"))
hl.bind(mod .. " + b", hy3.make_group("stack", { ephemeral = true }))
hl.bind(mod .. " + p", hy3.lock_tab())

-- Window state
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Focus movement (hy3)
hl.bind(mod .. " + l", hy3.move_focus("r"))
hl.bind(mod .. " + h", hy3.move_focus("l"))
hl.bind(mod .. " + k", hy3.move_focus("u"))
hl.bind(mod .. " + j", hy3.move_focus("d"))

-- Group tab switching
hl.bind(mod .. " + CTRL + h", hl.dsp.group.prev())
hl.bind(mod .. " + CTRL + l", hl.dsp.group.next())

-- Window movement (hy3)
hl.bind(mod .. " + SHIFT + l", hy3.move_window("r"))
hl.bind(mod .. " + SHIFT + h", hy3.move_window("l"))
hl.bind(mod .. " + SHIFT + k", hy3.move_window("u"))
hl.bind(mod .. " + SHIFT + j", hy3.move_window("d"))

-- Scratchpad
hl.bind(mod .. " + SHIFT + code:20", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(mod .. " + code:20", hl.dsp.workspace.toggle_special("scratchpad"))

-- Pypr scratchpad
hl.bind(mod .. " + t", hl.dsp.exec_cmd("pypr toggle term"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))

-- Workspaces
for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse binds
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
