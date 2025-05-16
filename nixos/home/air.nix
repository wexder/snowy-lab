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
      # ../programs/tmux.nix
    ];

    services.syncthing = {
      enable = true;
      settings = {
        folders = {
          "thunderbird" = {
            id = "thunderbird";
            path = "/Users/vladimirzahradnik/.thunderbird/";
            devices = ["polar-bear"];
          };
          "documents" = {
            id = "documents";
            path = "/Users/vladimirzahradnik/documents/";
            devices = ["polar-bear"];
          };
          "obsidian" = {
            id = "obsidian";
            path = "/Users/vladimirzahradnik/obsidian/";
            devices = ["polar-bear"];
          };
        };
        devices = {
          polar-bear = {
            id = "WYQIGNT-BE6FGPD-EW4X2WP-N7VQUV4-ASLKO3W-YZ2QW6H-IQUPC4E-7WW3NQ7";
          };
        };
      };
    };
    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";
    home.username = "vladimirzahradnik"; # TODO change
    home.homeDirectory = "/Users/vladimirzahradnik"; # TODO change
  };
}
