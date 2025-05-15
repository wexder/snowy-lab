{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file = {
    ".config/ghostty/config".source = ./ghostty/config;
  };
}
