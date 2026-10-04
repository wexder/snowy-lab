{
  config,
  stable,
  lib,
  ...
}:
let
  cfg = config.roles.cad;
  python = stable.python3.withPackages (
    ps: with ps; [
      pydantic
      requests
      atopile-easyeda2kicad
    ]
  );
  kicad = stable.kicad-testing.override {
    addons = [
      stable.kicadAddons.kikit
      stable.kicadAddons.kikit-library
    ];

    python3 = python;
  };
in
{
  options.roles.cad = {
    enable = lib.mkEnableOption "Enable CAD software";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # stable.freecad-wayland
      stable.jre21_minimal
      kicad
      stable.easyeda2kicad
      stable.freerouting
      stable.egl-wayland
      stable.openscad
      stable.opencascade-occt
    ];
  };
}
