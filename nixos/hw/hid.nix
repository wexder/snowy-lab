{ lib
, config
, pkgs
, modulesPath
, ...
}: {
  users.groups.plugdev = { };
  users.users.wexder.extraGroups = [ "plugdev" ];
  services.udev.extraRules = ''
    # Integrated biometrics
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="1300", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="7100", MODE="0666"
  '';
}
