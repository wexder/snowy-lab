{
  config,
  lib,
  ...
}:
let
  cfg = config.roles.desktop;

  # Everything here is themed from the same palette as the shell and the
  # compositor: pure black, red accents, slightly see-through. Edit the colours
  # in roles.quickshell.colors and the opacity in roles.desktop.opacity, not
  # here.
  palette = config.roles.quickshell.colors;
  font = config.roles.quickshell.font;
  opacity = toString cfg.opacity;

  # Layered over Breeze-Dark for every GTK application, GTK3 and GTK4 alike:
  # the two share nearly all of their CSS node names. The window itself is
  # see-through black and most of what sits on it is transparent, so the
  # opacity is the same across a window instead of stacking up; only text and
  # icons stay solid.
  widgetCss = ''
    @define-color snowy_base ${palette.base};
    @define-color snowy_surface ${palette.surface};
    @define-color snowy_surface_alt ${palette.surfaceAlt};
    @define-color snowy_overlay ${palette.overlay};
    @define-color snowy_text ${palette.text};
    @define-color snowy_subtext ${palette.subtext};
    @define-color snowy_muted ${palette.muted};
    @define-color snowy_primary ${palette.primary};
    @define-color snowy_secondary ${palette.secondary};
    @define-color snowy_on_primary ${palette.onPrimary};

    window.background,
    dialog.background {
      background-color: alpha(@snowy_base, ${opacity});
      color: @snowy_text;
    }

    /* Everything laid out on the window lets it show through. */
    .view,
    iconview,
    textview text,
    scrolledwindow,
    viewport,
    stack,
    paned,
    notebook,
    notebook > stack,
    list,
    row,
    frame,
    box,
    grid,
    toolbar,
    menubar,
    headerbar,
    .titlebar,
    actionbar,
    actionbar > revealer > box,
    statusbar,
    placessidebar,
    .sidebar,
    .shortcuts-pane {
      background-color: transparent;
      background-image: none;
      color: @snowy_text;
      border-color: @snowy_surface_alt;
      box-shadow: none;
    }

    frame > border,
    scrolledwindow,
    toolbar,
    menubar,
    headerbar,
    statusbar {
      border: none;
    }

    toolbar,
    headerbar {
      padding: 4px 6px;
    }

    statusbar {
      color: @snowy_muted;
      padding: 0 6px;
    }

    label:disabled {
      color: @snowy_muted;
    }

    /* Hover and selection */
    .view:hover,
    row:hover {
      background-color: alpha(@snowy_overlay, 0.45);
    }

    .view:selected,
    .view:selected:focus,
    iconview:selected,
    row:selected,
    textview text selection,
    entry selection,
    label selection {
      background-color: @snowy_primary;
      color: @snowy_on_primary;
    }

    .view:selected:backdrop,
    row:selected:backdrop {
      background-color: @snowy_overlay;
      color: @snowy_text;
    }

    rubberband,
    .rubberband {
      background-color: alpha(@snowy_primary, 0.25);
      border: 1px solid @snowy_primary;
    }

    /* Column headers */
    treeview.view header button {
      background-color: transparent;
      background-image: none;
      color: @snowy_muted;
      border: none;
      border-bottom: 1px solid @snowy_surface_alt;
      border-radius: 0;
      box-shadow: none;
      font-weight: normal;
    }

    treeview.view header button:hover {
      color: @snowy_text;
    }

    /* Buttons */
    button {
      background-color: alpha(@snowy_surface_alt, 0.8);
      background-image: none;
      color: @snowy_subtext;
      border: 1px solid transparent;
      border-radius: 4px;
      box-shadow: none;
      text-shadow: none;
      -gtk-icon-shadow: none;
    }

    button:hover {
      background-color: @snowy_overlay;
      color: @snowy_text;
    }

    button:disabled {
      background-color: transparent;
      color: @snowy_overlay;
    }

    button:focus {
      border-color: alpha(@snowy_primary, 0.6);
    }

    button:checked,
    button:active,
    button.suggested-action,
    button.default {
      background-color: @snowy_primary;
      color: @snowy_on_primary;
    }

    button.destructive-action {
      background-color: ${palette.error};
      color: @snowy_base;
    }

    toolbar button,
    headerbar button,
    button.flat {
      background-color: transparent;
    }

    toolbar button:hover,
    headerbar button:hover,
    button.flat:hover {
      background-color: @snowy_surface_alt;
    }

    /* The path bar marks the current folder as a toggled button. */
    toolbar button:checked,
    headerbar button:checked,
    .path-bar-button:checked {
      background-color: @snowy_primary;
      color: @snowy_on_primary;
    }

    /* Text fields */
    entry,
    spinbutton {
      background-color: alpha(@snowy_surface, 0.8);
      background-image: none;
      color: @snowy_text;
      caret-color: @snowy_secondary;
      border: 1px solid @snowy_surface_alt;
      border-radius: 4px;
      box-shadow: none;
    }

    entry:focus,
    spinbutton:focus {
      border-color: @snowy_primary;
    }

    spinbutton button,
    combobox button {
      border-radius: 4px;
    }

    /* Toggles, sliders and progress */
    check,
    radio {
      background-color: @snowy_surface;
      background-image: none;
      border: 1px solid @snowy_overlay;
      box-shadow: none;
    }

    check:checked,
    check:indeterminate,
    radio:checked {
      background-color: @snowy_primary;
      border-color: @snowy_primary;
      color: @snowy_on_primary;
    }

    switch {
      background-color: @snowy_surface_alt;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    switch:checked {
      background-color: @snowy_primary;
    }

    switch slider {
      background-color: @snowy_text;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    scale trough,
    progressbar trough,
    levelbar trough {
      background-color: @snowy_surface_alt;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    scale highlight,
    progressbar progress,
    levelbar block.filled {
      background-color: @snowy_primary;
      background-image: none;
      border: none;
    }

    scale slider {
      background-color: @snowy_text;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    *:link,
    button.link {
      color: @snowy_secondary;
    }

    /* Menus, popovers and tooltips sit on top of other content, so they
       are solid. */
    menu,
    .menu,
    .context-menu,
    popover,
    popover.background {
      background-color: @snowy_surface;
      color: @snowy_text;
      border: 1px solid @snowy_surface_alt;
      border-radius: 4px;
      padding: 4px;
    }

    menu menuitem,
    menubar > menuitem {
      border-radius: 4px;
      padding: 4px 8px;
    }

    menu menuitem:hover,
    menubar > menuitem:hover,
    modelbutton:hover {
      background-color: @snowy_primary;
      color: @snowy_on_primary;
    }

    menu separator,
    popover separator {
      background-color: @snowy_surface_alt;
      margin: 4px 0;
    }

    tooltip,
    tooltip.background {
      background-color: @snowy_surface;
      color: @snowy_text;
      border: 1px solid @snowy_surface_alt;
      border-radius: 4px;
    }

    /* Tabs */
    notebook > header {
      background-color: transparent;
      border-color: @snowy_surface_alt;
    }

    notebook > header tab {
      background-color: transparent;
      background-image: none;
      color: @snowy_muted;
      border: none;
      box-shadow: none;
      padding: 4px 10px;
    }

    notebook > header tab:checked {
      color: @snowy_text;
      box-shadow: inset 0 -2px @snowy_primary;
    }

    /* Dividers */
    separator {
      background-color: @snowy_surface_alt;
      background-image: none;
      min-width: 1px;
      min-height: 1px;
    }

    /* Breeze pads the handle out to make it easier to grab, which with a
       flat colour shows as a thick bar. */
    paned > separator {
      background-color: @snowy_surface_alt;
      background-image: none;
      border: none;
      margin: 0;
      padding: 0;
      min-width: 1px;
      min-height: 1px;
    }

    /* Slim scrollbars */
    scrollbar {
      background-color: transparent;
      border: none;
    }

    scrollbar slider {
      background-color: @snowy_overlay;
      border: 2px solid transparent;
      border-radius: 6px;
      min-width: 6px;
      min-height: 6px;
    }

    scrollbar slider:hover {
      background-color: @snowy_muted;
    }

    scrollbar slider:active {
      background-color: @snowy_primary;
    }

    /* Side panes: Thunar's, and the file chooser's */
    .thunar .sidebar .view,
    .thunar .shortcuts-pane .view,
    placessidebar row {
      color: @snowy_subtext;
    }

    placessidebar row:selected {
      color: @snowy_on_primary;
    }
  '';
in
{
  config = lib.mkIf (cfg.enable && cfg.kind == "hyprland") {
    gtk.font = {
      name = font.family;
      size = 11;
    };

    # Read by ghostty/config through its `config-file` line, and loaded after
    # it, so these win over the colours written there.
    xdg.configFile."ghostty/theme".text = ''
      background = ${palette.base}
      foreground = ${palette.text}
      background-opacity = ${opacity}
      cursor-color = ${palette.primary}
      cursor-text = ${palette.onPrimary}
      selection-background = ${palette.primary}
      selection-foreground = ${palette.onPrimary}
      palette = 1=${palette.primary}
      palette = 9=${palette.secondary}
    '';

    # libadwaita and GTK4 applications follow the portal's accent colour.
    dconf.settings."org/gnome/desktop/interface".accent-color = "red";

    gtk.gtk3.extraCss = widgetCss;

    # libadwaita is additionally recoloured through its named colours.
    gtk.gtk4.extraCss = ''
      @define-color accent_bg_color ${palette.primary};
      @define-color accent_fg_color ${palette.onPrimary};
      @define-color accent_color ${palette.secondary};
      @define-color window_bg_color ${palette.base};
      @define-color window_fg_color ${palette.text};
      @define-color view_bg_color ${palette.base};
      @define-color view_fg_color ${palette.text};
      @define-color headerbar_bg_color ${palette.base};
      @define-color headerbar_fg_color ${palette.text};
      @define-color headerbar_backdrop_color ${palette.base};
      @define-color sidebar_bg_color ${palette.base};
      @define-color sidebar_fg_color ${palette.text};
      @define-color sidebar_backdrop_color ${palette.base};
      @define-color popover_bg_color ${palette.surface};
      @define-color popover_fg_color ${palette.text};
      @define-color dialog_bg_color ${palette.surface};
      @define-color dialog_fg_color ${palette.text};
      @define-color card_bg_color ${palette.surface};
      @define-color card_fg_color ${palette.text};
    

      ${widgetCss}
    '';
  };
}
