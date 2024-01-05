{ config, pkgs, lib, ... }:
let
  cfg = config.roles.jupyter;
  pythonJupyter = pkgs.python3.withPackages (ps: with ps; [ jupyterlab jupyterlab-lsp python-lsp-server ]);
  pythonKernel = pkgs.python310.withPackages (pythonPackages: with pythonPackages;
    [
      jupyterlab
      jupyterlab-lsp
      ipykernel
      ipython
      pandas
      pytorch
      scikit-learn
    ]);
in
{
  options.roles.jupyter = {
    enable = lib.mkEnableOption "Enable jupyter lab";
  };

  config = lib.mkIf cfg.enable
    {

      users.groups.jupyter.members = [ "wexder" ];
      users.groups.jupyter = { };

      # environment.systemPackages = with pkgs;[
      #   pythonKernel
      # ];

      services.jupyter = {
        enable = true;
        command = "jupyter-lab";
        user = "wexder";
        group = "jupyter";
        password = "1234";
        notebookDir = "~/development/jupyter";
        package = pythonJupyter;
        kernels = {
          python3 =
            {
              displayName = "Python 3 for machine learning";
              env = {
                CUDA_PATH = "${pkgs.cudatoolkit}";
                LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib";
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
