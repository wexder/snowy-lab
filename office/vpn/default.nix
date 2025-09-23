{ modulesPath, config, lib, pkgs, ip, ... }: {
  imports = [
    ./caddy.nix
    ./coredns.nix
    ./dashboard.nix
    ./networking.nix
  ];

  age = {
    secrets = {
      oudaddy.file = ./secrets/oudaddy.age;
    };
  };
}
