{ config, stable, pkgs, lib, ... }:
let
  cfg = config.roles.cad;
  py-slvr = pkgs.python3Packages.buildPythonPackage rec {
    pname = "slvs_py";
    version = "0.21.2";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "realthunder";
      repo = "slvs_py";
      rev = "master";
      hash = "sha256-aG9iWz0Ef+t9jHwdtwjev+cd/iNUgMLnSznVJ4+dFdM=";
    };

    nativeBuildInputs = [
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.skbuild
    ];

    propagatedBuildInputs = [
    ];
  };
in
{
  options.roles.cad = {
    enable = lib.mkEnableOption "Enable CAD software";
  };

  config = lib.mkIf cfg.enable
    {

      environment.systemPackages = [
        pkgs.freecad-wayland
        stable.kicad
        stable.openscad
        stable.opencascade-occt
        # (pkgs.python3.withPackages (python-pkgs: [
        #   # py-slvr
        # ]))
      ];
    };
}
