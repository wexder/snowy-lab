{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  }
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.cudaPackages.cudatoolkit
    pkgs.python3Packages.pytorch
  ];

  shellHook = ''
    echo "You are now using a NIX environment"
    export CUDA_PATH=${pkgs.cudatoolkit}
  '';
}
