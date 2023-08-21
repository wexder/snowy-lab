{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "my_git_username";
    userEmail = "my_git_username@gmail.com";
  };
}
