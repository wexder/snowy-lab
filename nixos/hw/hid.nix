{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  users.groups.plugdev = { };
  users.users.wexder.extraGroups = [ "plugdev" ];
  services.udev.extraRules = ''
    # Integrated biometrics
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="1300", MODE="0666"
    # Kojak
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="7100", MODE="0666"
    # Five-O
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="1500", MODE="0666"

    # M5stack
    SUBSYSTEM=="tty", SUBSYSTEMS=="usb", ATTRS{idVendor}=="05e3", ATTRS{idProduct}=="0608", MODE="0666"
    SUBSYSTEM=="tty", SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"

    # ESP
    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="00??", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="00??", MODE="0666"
    SUBSYSTEM=="tty", SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="00??", MODE="0666"
  '';
}
