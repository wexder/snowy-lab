{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.roles.desktop;

  # One entry in Thunar's "custom actions" context menu. `appliesTo` is the
  # list of file kinds the action is offered for, which uca.xml spells as
  # empty elements.
  action =
    {
      id,
      name,
      icon,
      command,
      description,
      appliesTo,
      patterns ? "*",
    }:
    ''
      <action>
        <icon>${icon}</icon>
        <name>${name}</name>
        <submenu></submenu>
        <unique-id>${id}</unique-id>
        <command>${lib.escapeXML command}</command>
        <description>${description}</description>
        <range></range>
        <patterns>${patterns}</patterns>
        ${lib.concatMapStrings (kind: "<${kind}/>") appliesTo}
      </action>
    '';

  anyFile = [
    "directories"
    "audio-files"
    "image-files"
    "other-files"
    "text-files"
    "video-files"
  ];
in
{
  config = lib.mkIf (cfg.enable && cfg.kind == "hyprland") {
    # Thunar keeps its preferences in xfconf. Only the keys listed here are
    # pinned; anything else changed in its preferences dialog still sticks.
    xfconf.settings.thunar = {
      "default-view" = "ThunarDetailsView";
      "last-view" = "ThunarDetailsView";
      "last-details-view-zoom-level" = "THUNAR_ZOOM_LEVEL_38_PERCENT";
      "last-location-bar" = "ThunarLocationButtons";
      # Still reachable with F10, and through the toolbar's menu button.
      "last-menubar-visible" = false;
      "last-image-preview-visible" = false;
      "last-toolbar-items" = lib.concatStringsSep "," [
        "back:1"
        "forward:1"
        "open-parent:1"
        "location-bar:1"
        "search:1"
        "view-switcher:1"
        "menu:1"
        "open-home:0"
        "new-tab:0"
        "new-window:0"
        "toggle-split-view:0"
        "undo:0"
        "redo:0"
        "zoom-out:0"
        "zoom-in:0"
        "zoom-reset:0"
        "view-as-icons:0"
        "view-as-detailed-list:0"
        "view-as-compact-list:0"
        "reload:0"
      ];
      "misc-folders-first" = true;
      "misc-date-style" = "THUNAR_DATE_STYLE_SHORT";
      "misc-symbolic-icons-in-toolbar" = true;
      "misc-symbolic-icons-in-sidepane" = true;
      "misc-thumbnail-draw-frames" = false;
      # Hyprland draws the border; a client-side titlebar would only add a
      # second one.
      "misc-use-csd" = false;
    };

    # Custom actions. This file is generated, so actions added in Thunar's own
    # editor are lost on the next switch; add them here instead.
    xdg.configFile."Thunar/uca.xml" = {
      force = true;
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
        ${lib.concatMapStrings action [
          {
            id = "snowy-terminal-here";
            name = "Open Ghostty Here";
            icon = "utilities-terminal";
            command = "ghostty +new-window --working-directory=%f";
            description = "Open a terminal in this folder";
            appliesTo = [ "directories" ];
          }
          {
            id = "snowy-open-in-nvim";
            name = "Open in Neovim";
            icon = "nvim";
            command = "ghostty +new-window --working-directory=%d -e nvim %F";
            description = "Edit the selection in Neovim";
            appliesTo = anyFile;
          }
          {
            id = "snowy-copy-path";
            name = "Copy Path";
            icon = "edit-copy";
            command = "sh -c 'printf %s \"$*\" | wl-copy' sh %F";
            description = "Copy the full path to the clipboard";
            appliesTo = anyFile;
          }
          {
            id = "snowy-set-wallpaper";
            name = "Set as Wallpaper";
            icon = "preferences-desktop-wallpaper";
            command = "sh -c 'hyprctl hyprpaper wallpaper \",$1\"' sh %f";
            description = "Show this image as the desktop background";
            appliesTo = [ "image-files" ];
          }
        ]}
        </actions>
      '';
    };
  };
}
