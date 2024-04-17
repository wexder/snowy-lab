{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gow";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "mitranim";
    repo = "gow";
    rev = "af11a6e1e9ebccdcdace2a6df619355b85494d74";
    hash = "sha256-NmjJd3GVImCtYo5CxGnQHHPERx5R0sD4bzBsbxNGc3o=";
  };

  modRoot = ".";
  vendorHash = "sha256-Xw9V7bYaSfu5kA2505wmef2Ns/Y0RHKbZHUkvCtVNSM=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];
}
