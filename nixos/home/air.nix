{
  config,
  pkgs,
  ...
}:
{
  users.users.vladimirzahradnik = {
    name = "vladimirzahradnik";
    home = "/Users/vladimirzahradnik";
  };

  home-manager.users.vladimirzahradnik =
    { pkgs, ... }:
    {
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
              devices = [ "polar-bear" ];
            };
            "documents" = {
              id = "documents";
              path = "/Users/vladimirzahradnik/documents/";
              devices = [ "polar-bear" ];
            };
            "obsidian" = {
              id = "obsidian";
              path = "/Users/vladimirzahradnik/obsidian/";
              devices = [ "polar-bear" ];
            };
          };
          devices = {
            polar-bear = {
              id = "DTSBGY4-AHFZVTH-MKZOZSP-5XQGZ2Y-LHEE6QL-NWMI44M-5R2KBF4-SDPZPQ6";
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
