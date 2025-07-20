{ config
, lib
, pkgs
, ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Vladimir Zahradnik";
    userEmail = "wexder19@gmail.com";
  };
}
