{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.roles.llm;
in {
  options.roles.llm = {
    enable = lib.mkEnableOption "Enable local llm";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      openFirewall = false;
      host = "0.0.0.0";
      environmentVariables = {
        OLLAMA_ORIGINS = "http://192.168.240.19:3888";
      };
    };
    services.nextjs-ollama-llm-ui = {
      enable = true;
      hostname = "0.0.0.0";
      port = 3888;
      ollamaUrl = "http://192.168.240.19:11434";
    };
  };
}
