{
  isLinux,
  lib,
  ...
}: let
  isDarwin = !isLinux;
in {
  imports =
    [
      ./officeWg.nix
    ]
    ++ lib.optionals isLinux [
      ./linux
    ]
    ++ lib.optionals isDarwin [
      ./darwin
    ];
}
