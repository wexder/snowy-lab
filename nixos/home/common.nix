{
  config,
  pkgs,
  ...
}: {
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
  home.username = "wexder";
  home.homeDirectory = "/home/wexder";
  nixpkgs.config.allowUnfreePredicate = _: true;

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };

  imports = [
    ../programs/nvim.nix
  ];
}
