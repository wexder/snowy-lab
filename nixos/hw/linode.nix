{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

  services.getty = {
    autologinUser = "wexder";
  };

  security.sudo.extraRules = [
    {
      users = ["wexder"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD" "SETENV"];
        }
      ];
    }
  ];

  swapDevices = [];
  nix.settings.max-jobs = lib.mkDefault 2;

  # files for rebuilding
  environment.etc = {
    configuration = {
      source = ../templates/configuration.nix;
      target = "/nixos/configuration.nix";
    };
    flake = {
      source = ../templates/flake.nix;
      target = "/nixos/flake.nix";
    };
  };
}
