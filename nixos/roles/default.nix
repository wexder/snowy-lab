{
  isLinux,
  lib,
  ...
}: let
  isDarwin = !isLinux;
in {
  imports =
    [
      ./dev.nix
      ./officeWg.nix
    ]
    ++ lib.optionals isLinux [
      ./linux
    ]
    ++ lib.optionals isDarwin [
      ./darwin
    ];
}
