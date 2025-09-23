{ buildGoModule
}:
buildGoModule {
  name = "caddy";
  version = "v0.0.1";
  src = ./wrapper;

  vendorHash = "sha256-oCyPf8xoOOsAp1XD47bO2MW0VCOvC+O+HWYGkC9cOPY=";

  postInstall = ''
    mv $out/bin/wradyy $out/bin/caddy
  '';

  meta = {
    mainProgram = "caddy";
  };
}
