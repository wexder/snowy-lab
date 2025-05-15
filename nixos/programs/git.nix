{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Vladimir Zahradnik";
    userEmail = "wexder19@gmail.com";
  };
}
