{
  pkgs,
  attrs,
  ...
}: {
  imports = [
    ../roles
  ];

  networking = {
    hostName = "snowflake";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
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
    pkgs.obsidian
    pkgs.slack
    pkgs.raycast
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = attrs.rev or attrs.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow TouchID for sudo
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];
    brews = [];
    casks = ["ghostty" "zen" "signal"];
  };

  system = {
    keyboard = {
      enableKeyMapping = true;
      swapLeftCtrlAndFn = true;
    };
    defaults = {
      dock.autohide = true;
      dock.mru-spaces = false;
      finder.AppleShowAllExtensions = true;
      finder.FXPreferredViewStyle = "clmv";
      loginwindow.LoginwindowText = "codegrowers.com";
      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 0;
    };
  };

  age = {
    secrets = {
      airWgPk = {
        file = ./secrets/air_cg_wg_pk.age;
      };
    };

    identityPaths = [
      "/Users/vladimirzahradnik/.ssh/age"
    ];
  };

  roles = {
    aerospace = {
      enable = true;
    };
  };
}
