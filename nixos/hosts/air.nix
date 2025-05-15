{ config, pkgs, attrs, ... }:
{
  networking = {
    hostName = "snowflake";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.neovim
      pkgs.git
      pkgs.tmux
      pkgs.tmux-sessionizer
      pkgs.jq
      pkgs.neovim-unwrapped
      pkgs.wget
      pkgs.curl
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.unzip
      pkgs.ripgrep
      pkgs.age
      pkgs.ssh-to-age
    ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;  # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = attrs.rev or attrs.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";
  
      taps = [];
      brews = [];
      casks = [ "ghostty" ];
  };

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "codegrowers.com";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 0;
  };
}
