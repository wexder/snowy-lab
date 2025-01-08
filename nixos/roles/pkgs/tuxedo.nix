{ alsa-lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, qt6
, mesa
, wrapGAppsHook3
, xorg
, nss
, lib
, systemd
}:

let
  mirror = "https://deb.tuxedocomputers.com/ubuntu/pool/main/t/tuxedo-control-center/";
in
stdenv.mkDerivation rec {
  pname = "tuxedo-control-center";
  version = "2.1.13-4";

  src = fetchurl {
    url = "${mirror}/tuxedo-control-center_${version}_amd64.deb";
    hash = "sha256-xdMFQlBjc06+a5j4nMnPQMVOCo4uLFo2uOesbvHRgRw=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    qt6.wrapQtAppsHook
    xorg.libxshmfence
    nss
    mesa
    alsa-lib
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    qt6.qtbase
  ];

  runtimeDependencies = [
    # This is a little tricky. Without it the app starts then crashes. Then it
    # brings up the crash report, which also crashes. `strace -f` hints at a
    # missing libudev.so.0.
    (lib.getLib systemd)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -av usr $out/bin
    cp -av opt $out
    chmod -R 755 $out/opt/tuxedo-control-center/
    ln -s $out/opt/tuxedo-control-center/tuxedo-control-center $out/bin/tuxedo-control-center

    install -D -t $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/99-webcam.rules 99-webcam.rules
    install -Dm644 $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tuxedo-control-center.desktop $out/usr/share/applications/tuxedo-control-center.desktop
    install -Dm644 $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.policy $out/usr/share/polkit-1/actions/com.tuxedocomputers.tccd.policy
    install -Dm644 $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.conf $out/usr/share/dbus-1/system.d/com.tuxedocomputers.tccd.conf
    install -Dm644 $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd.service $out/etc/systemd/system/tccd.service
    install -Dm644 $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd-sleep.service $out/etc/systemd/system/tccd-sleep.service
  '';

  dontWrapQtApps = true;

  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp -r usr $out
  #   cp -r usr/share $out/share
  #
  #   ln -s $out/usr/bin/opera $out/bin/opera
  # '';
}


# { alsa-lib
# , atk
# , cairo
# , cups
# , curl
# , dbus
# , dpkg
# , expat
# , fetchurl
# , fontconfig
# , freetype
# , gdk-pixbuf
# , glib
# , gtk3
# , gtk4
# , lib
# , libX11
# , libxcb
# , libXScrnSaver
# , libXcomposite
# , libXcursor
# , libXdamage
# , libXext
# , libXfixes
# , libXi
# , libXrandr
# , libXrender
# , libXtst
# , libdrm
# , libnotify
# , libpulseaudio
# , libuuid
# , libxshmfence
# , mesa
# , nspr
# , nss
# , pango
# , stdenv
# , systemd
# , at-spi2-atk
# , at-spi2-core
# , autoPatchelfHook
# , wrapGAppsHook3
# , qt6
# , proprietaryCodecs ? false
# , vivaldi-ffmpeg-codecs
# }:
#
# let
#   mirror = "https://get.geo.opera.com/pub/opera/desktop";
# in
# stdenv.mkDerivation rec {
#   pname = "opera";
#   version = "113.0.5230.47";
#
#   src = fetchurl {
#     url = "${mirror}/${version}/linux/${pname}-stable_${version}_amd64.deb";
#     hash = "sha256-0RQTcROUv85yE6ceLkyF09/++WrvK828h5hoN1QYpCE=";
#   };
#
#   unpackPhase = "dpkg-deb -x $src .";
#
#   nativeBuildInputs = [
#     dpkg
#     autoPatchelfHook
#     wrapGAppsHook3
#     qt6.wrapQtAppsHook
#   ];
#
#   buildInputs = [
#     alsa-lib
#     at-spi2-atk
#     at-spi2-core
#     atk
#     cairo
#     cups
#     curl
#     dbus
#     expat
#     fontconfig.lib
#     freetype
#     gdk-pixbuf
#     glib
#     gtk3
#     libX11
#     libXScrnSaver
#     libXcomposite
#     libXcursor
#     libXdamage
#     libXext
#     libXfixes
#     libXi
#     libXrandr
#     libXrender
#     libXtst
#     libdrm
#     libnotify
#     libuuid
#     libxcb
#     libxshmfence
#     mesa
#     nspr
#     nss
#     pango
#     stdenv.cc.cc.lib
#     qt6.qtbase
#   ];
#
#   runtimeDependencies = [
#     # Works fine without this except there is no sound.
#     libpulseaudio.out
#
#     # This is a little tricky. Without it the app starts then crashes. Then it
#     # brings up the crash report, which also crashes. `strace -f` hints at a
#     # missing libudev.so.0.
#     (lib.getLib systemd)
#
#     # Error at startup:
#     # "Illegal instruction (core dumped)"
#     gtk3
#     gtk4
#   ] ++ lib.optionals proprietaryCodecs [
#     vivaldi-ffmpeg-codecs
#   ];
#
#   dontWrapQtApps = true;
#
#   installPhase = ''
#     mkdir -p $out/bin
#     cp -r usr $out
#     cp -r usr/share $out/share
#
#     # we already using QT6, autopatchelf wants to patch this as well
#     rm $out/usr/lib/x86_64-linux-gnu/opera/libqt5_shim.so
#     ln -s $out/usr/bin/opera $out/bin/opera
#   '';
#
#   meta = with lib; {
#     homepage = "https://www.opera.com";
#     description = "Faster, safer and smarter web browser";
#     platforms = [ "x86_64-linux" ];
#     license = licenses.unfree;
#     sourceProvenance = with sourceTypes; [ binaryNativeCode ];
#     maintainers = with maintainers; [ kindrowboat ];
#   };
# }
#
