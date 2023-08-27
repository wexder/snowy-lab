{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Vladimir Zahradnij";
    userEmail = "wexder19@gmail.com";
  };
}
