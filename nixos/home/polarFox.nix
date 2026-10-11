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
      scale = 1.33;
    };

    # The shell is a home-manager module, so it is configured here rather than
    # in nixos/hosts/polarFox.nix with the system-level roles.
    quickshell = {
      enable = true;
    };
  };
}
