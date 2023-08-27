{ config, lib, pkgs, ... }:
{
  home.file.".config/nvim".source = (pkgs.fetchFromGitHub {
    url = "ssh://git@github.com/wexder/nvim.IDE";
    ref = "master";
  });
}
