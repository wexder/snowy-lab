{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../programs/ghostty.nix
    ../programs/alacritty.nix
    ../programs/git.nix
    ../programs/virtManager.nix
    ../programs/zsh.nix
    ./common.nix
  ];

  home.file = {
    # Stable SDK symlinks
    "SDKs/Java/17".source = pkgs.jdk17.home;
    "SDKs/Java/11".source = pkgs.jdk11.home;
    "SDKs/Java/8".source = pkgs.jdk8.home;
  };
}
