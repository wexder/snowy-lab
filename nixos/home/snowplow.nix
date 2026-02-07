{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/zsh.nix
    ./common.nix
  ];
}
