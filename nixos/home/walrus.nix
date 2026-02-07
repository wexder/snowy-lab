{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../programs/ghostty.nix
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/zsh.nix
    # ../programs/bambu.nix
    ./common.nix
  ];
}
