{ config, lib, pkgs, ... }:
{
  home.file.".config/nvim".source = (builtins.fetchGit {
    url = "git@github.com/wexder/nvim.IDE";
    ref = "master";
  });
}
