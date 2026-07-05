{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../programs/ghostty.nix
    ../programs/alacritty.nix
    ../programs/git.nix
    ../programs/sway.nix
    ../programs/zsh.nix
    # ../programs/bambu.nix
    ./common.nix
  ];
}
