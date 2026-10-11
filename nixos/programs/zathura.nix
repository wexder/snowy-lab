{
  config,
  lib,
  ...
}:
let
  cfg = config.roles.desktop;

  # Themed from the same palette as the shell. Edit the colours in
  # roles.quickshell.colors, not here.
  palette = config.roles.quickshell.colors;
  font = config.roles.quickshell.font;

  # Zathura takes translucent colours as "rgba(r, g, b, a)", where the palette
  # has "#RRGGBB".
  rgba =
    colour: alpha:
    let
      hex = lib.removePrefix "#" colour;
      channel = start: toString (lib.fromHexString (builtins.substring start 2 hex));
    in
    "rgba(${channel 0}, ${channel 2}, ${channel 4}, ${toString alpha})";

  # The reader sits next to the terminal and looks like it: see-through
  # black, near-white text.
  background = rgba palette.base cfg.opacity;
  # Bars are a touch more solid so their text stays readable over a busy
  # wallpaper.
  bar = rgba palette.base 0.92;
  clear = rgba palette.base 0;
in
{
  config = lib.mkIf (cfg.enable && cfg.kind == "hyprland") {
    programs.zathura = {
      enable = true;
      options = {
        font = "${font.family} 11";
        selection-clipboard = "clipboard";
        adjust-open = "width";
        guioptions = "s";
        statusbar-home-tilde = true;
        window-title-basename = true;

        default-bg = background;
        default-fg = palette.text;

        statusbar-bg = bar;
        statusbar-fg = palette.muted;
        inputbar-bg = bar;
        inputbar-fg = palette.text;

        notification-bg = bar;
        notification-fg = palette.text;
        notification-error-bg = bar;
        notification-error-fg = palette.error;
        notification-warning-bg = bar;
        notification-warning-fg = palette.warning;

        completion-bg = bar;
        completion-fg = palette.subtext;
        completion-group-bg = bar;
        completion-group-fg = palette.muted;
        completion-highlight-bg = palette.primary;
        completion-highlight-fg = palette.onPrimary;

        index-bg = clear;
        index-fg = palette.text;
        index-active-bg = palette.primary;
        index-active-fg = palette.onPrimary;

        highlight-color = rgba palette.warning 0.4;
        highlight-active-color = rgba palette.primary 0.5;

        # Pages are recoloured to match: the paper becomes transparent, so
        # the window background shows through, and the ink becomes the
        # palette's text colour. ctrl+r switches back to the document's own
        # colours.
        recolor = true;
        recolor-keephue = true;
        recolor-reverse-video = true;
        recolor-lightcolor = clear;
        recolor-darkcolor = palette.text;
      };
    };
  };
}
