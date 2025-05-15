{
  config,
  pkgs,
  ...
}: {
  users.users.vladimirzahradnik = {
    name = "vladimirzahradnik";
    home = "/Users/vladimirzahradnik";
  };

  home-manager.users.vladimirzahradnik = {pkgs, ...}: {
    imports = [
      ../programs/ghostty.nix
      ../programs/git.nix
      ../programs/zsh.nix
      ../programs/nvim.nix
      ../programs/aerospace.nix
    ];

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";
    home.username = "vladimirzahradnik"; # TODO change
    home.homeDirectory = "/Users/vladimirzahradnik"; # TODO change
  };
}
