{ lib, config, pkgs, modulesPath, ... }:
{
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
  '';
}


