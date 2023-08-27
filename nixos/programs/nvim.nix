{ config, lib, pkgs, ... }:
{
  home.file.".config/nvim".source = (pkgs.fetchFromGitHub {
    owner = "wexder";
    repo = "nvim.IDE";
    rev = "01c0d0024cce340170ec71e5f73bcfbd2e633e8d";
    sha256 = "0wzrb627508y5js2i6n75lprfhw8raxi82fvvzd4qkhw5ml8ligc";
  });

  home.file."~/.local/share/nvim/site/pack/packer/start/packer.nvim".source = (
    pkgs.fetchFromGitHub {
      owner = "wbthomason";
      repo = "packer.nvim";
      rev = "ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3";
      sha256 = "0lvpflpm7mhv39dglxdvmilj72xgxx5j614ll06mcxycv2k3xcvw";
    }
  );
}
