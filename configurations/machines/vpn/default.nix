args@{ config, pkgs, ... }:
let
  ip = "10.1.1.231";
in
{
  imports = [
    ./system.nix
    (./networking.nix (
      args
        { ip = ip; }
    ))
    (./dns.nix (
      args
        { ip = ip; }
    ))
  ];
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    netclient
  ];
  services.netclient = {
    enable = true;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9 wexder@archlinux"
  ];
}
