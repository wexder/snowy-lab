{ config, pkgs, lib, ... }:
let
  cfg = config.roles.jupyter;
  pythonJupyter = pkgs.python3.withPackages (ps: with ps; [ jupyterlab jupyterlab-lsp python-lsp-server ]);
  pythonKernel = pkgs.python310.withPackages (pythonPackages: with pythonPackages;
    [
      pytorch-bin
      jupyterlab
      jupyterlab-lsp
      ipykernel
      ipython
      pandas
      scikit-learn
    ]);
  cuda = pkgs.cudaPackages.cudatoolkit;
  cudnn = pkgs.cudaPackages.cudnn;
in
{
  options.roles.jupyter = {
    enable = lib.mkEnableOption "Enable jupyter lab";
  };

  config = lib.mkIf cfg.enable
    {
      nixpkgs.config = {
        cudaSupport = true;
        cudaVersion = "12";
      };

      users.groups.jupyter.members = [ "wexder" ];
      users.groups.jupyter = { };

      environment.systemPackages = with pkgs;[
        pythonKernel
      ];

      services.jupyter = {
        enable = true;
        command = "jupyter-lab";
        user = "wexder";
        group = "jupyter";
        password = "1234";
        notebookDir = "~/development/jupyter";
        package = pythonJupyter;
        kernels = {
          python3 = {
            displayName = "Python 3 for machine learning";
            env = {
              CUDA_PATH = "${cuda}";
              CUDATKDIR = "${cuda}";
              # might set too many things, can be probably simplified
              LD_LIBRARY_PATH = "/usr/lib/x86_64-linux-gnu:${pkgs.mkl}/lib:${pkgs.libsndfile.out}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${cuda}/lib:${cuda.lib}/lib:${cudnn}/lib:$LD_LIBRARY_PATH";
              EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
              EXTRA_CCFLAGS = "-I/usr/include";
            };
            argv = [
              "${pythonKernel.interpreter}"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
          };
        };
      };
    };
}
