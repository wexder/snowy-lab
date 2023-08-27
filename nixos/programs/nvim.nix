{ config, lib, pkgs, ... }:
{
  home.file.".config/nvim".source = (builtins.fetchGit {
    url = "ssh://git@github.com/wexder/nvim.IDE";
    ref = "master";
    sha256 = "0wzrb627508y5js2i6n75lprfhw8raxi82fvvzd4qkhw5ml8ligc";
  });
}
