{ config, pkgs, lib, ... }:
let
  cfg = config.roles.jupyter;
in
{
  options.roles.jupyter = {
    enable = lib.mkEnableOption "Enable jupyter lab";
  };

  config = lib.mkIf cfg.enable
    {
      services.jupyter = {
        enable = true;
        command = "jupyter-lab";
        notebookDir = "/home/wexder/development/jupyter";
        kernels = {
          python3 =
            let
              env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages;
                [
                  ipykernel
                  pandas
                  pytorch
                  scikit-learn
                ]));
            in
            {
              displayName = "Python 3 for machine learning";
              argv = [
                "${env.interpreter}"
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