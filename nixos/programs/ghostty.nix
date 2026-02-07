{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    ".config/ghostty/config".source = ./ghostty/config;
  };

  systemd.user.services."app-com.mitchellh.ghostty" = {
    Unit = {
      Description = "Ghostty";
      After = [
        "graphical-session.target"
        "dbus.socket"
      ];
      Requires = "dbus.socket";
      X-RestartIfChanged = false;
    };
    Service = {
      Type = "dbus";
      BusName = "com.mitchellh.ghostty";
      ReloadSignal = "SIGUSR2";
      ExecStart = "${lib.getExe config.programs.ghostty.package} --gtk-single-instance=true --initial-window=false";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
