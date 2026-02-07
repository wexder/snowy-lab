{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../programs/ghostty.nix
    ../programs/git.nix
    ../programs/desktop.nix
    ../programs/sway.nix
    ../programs/hyprland.nix
    ../programs/virtManager.nix
    ../programs/zsh.nix
    ./common.nix
  ];

  roles = {
    desktop = {
      enable = true;
      kind = "hyprland";
    };
  };
}
