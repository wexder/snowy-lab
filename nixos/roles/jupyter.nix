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

      users.groups.jupyter.members = [ "wexder" ];
      users.users.jupyter.group = "jupyter";
      users.groups.jupyter = { };

      environment.systemPackages = with pkgs; [
        (python311.withPackages (ps: with ps; [ jupyterlab ]))
      ];

      services.jupyter = {
        enable = true;
        command = "jupyter-lab";
        user = "jupyter";
        group = "jupyter";
        password = "1234";
        notebookDir = "/home/wexder/development/jupyter";
        package = pkgs.python311.pkgs.notebook;
        kernels = {
          python3 =
            let
              env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages;
                [
                  jupyterlab
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
