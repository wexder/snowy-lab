{ lib, config, pkgs, modulesPath, ... }:
{
  users.groups.plugdev = { };
  users.users.wexder.extraGroups = [ "plugdev" ];
  services.udev.extraRules = ''
    # Make the event device node associated with the CM touch chip readers accessible by everyone
    DRIVERS=="usb", ATTRS{idVendor}=="147e", ATTRS{idProduct}=="2016",  MODE="0666"
    # DigitalPersona 5xxx readers
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000b", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000c", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000d", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000e", MODE="0666"
    # DigitalPersona 4000B/4500 readers
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="0008", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="0009", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000a", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000a", MODE="0666"
    # Matra morphis
    DRIVERS=="usb", ATTRS{idVendor}=="2c0f", ATTRS{idProduct}=="4100", MODE="0666"
    # Integrated biometrics
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="1300", MODE="0666"
    DRIVERS=="usb", ATTRS{idVendor}=="113f", ATTRS{idProduct}=="7100", MODE="0666"

    # Epson
    DRIVERS=="usb", ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="0e28", MODE="0666"

    # USB to uart
    DRIVERS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0777"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0777"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS={idProduct}=="6001", OWNER="user", MODE="0777", GROUP="dialout"

    # Lenovo table
    # 17ef:201c
    SUBSYSTEM=="usb", ATTR{idVendor}=="17ef", MODE="0666", GROUP="plugdev"

    # Pixel
    # 18d1
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666"
  '';
}


