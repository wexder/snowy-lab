{ config, lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window.opacity = 0.85;
      scrolling.history = 50000;

      font = {
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold Italic";
        };
      };

      # Point size
      # size = 12.0;
      colors = {
        primary = {
          background = "#000000";
          foreground = "#F9F9F9";
          dim_foreground = "#000000";
          bright_foreground = "#000000";
        };
      };
    };
  };
}
