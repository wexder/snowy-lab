{ config, lib, pkgs, ... }:
{
  programs.neovim.plugins = [
    pkgs.vimPlugins.packer-nvim
  ];

  # home.file.".config/nvim".source = (pkgs.fetchFromGitHub {
  #   owner = "wexder";
  #   repo = "nvim.IDE";
  #   rev = "01c0d0024cce340170ec71e5f73bcfbd2e633e8d";
  #   sha256 = "0wzrb627508y5js2i6n75lprfhw8raxi82fvvzd4qkhw5ml8ligc";
  # });
}
