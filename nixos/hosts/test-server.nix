{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "test-server";
    firewall = {
      enable = false;
    };

    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.ghostty # testing
  ];

  users.users.wexder.password = "test";
  users.users.wexder.hashedPasswordFile = null;

  roles = {
    docker = {
      enable = true;
    };
    # dev = {
    #   enable = true;
    # };
    # lsp = {
    #   go = true;
    #   rust = true;
    #   zig = true;
    #   cpp = true;
    # };
    xMinimalDesktop = {
      enable = true;
    };
    # virtualisation = {
    #   enable = true;
    # };
  };
}
