{ ... }:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = false;
    };
    GATT = {
      Cache = "no";
      Channels = 1;
    };
  };
}
