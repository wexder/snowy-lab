{ config
, lib
, pkgs
, utils
, ...
}:
let
  cfg = config.roles.wyoming;
  piper = pkgs.wyoming-piper.overrideAttrs (old: {
    version = "1.6.4";
    src = pkgs.fetchFromGitHub {
      owner = "rhasspy";
      repo = "wyoming-piper";
      rev = "78e890bd2846aba6ba07517a2c6afacf4a961482";
      hash = "sha256-i3PB77lwvPDaSIR2nSHE1V3Nvjguj7X61vLoE8KVSXI=";
    };

    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      pkgs.piper-tts
      pkgs.python3Packages.sentence-stream
    ];

    pythonRelaxDeps = [
      "regex"
      "wyoming"
      "sentence-stream"
    ];

    disabledTests = [
      # network access
      "test_piper"
    ];

    doInstallCheck = false;
  });
in
{
  options.roles.wyoming = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable ({
    services.wyoming.openwakeword = {
      enable = true;
      preloadModels = [
        "hey_jarvis"
        "ok_nabu"
      ];
    };
    services.wyoming.piper = {
      package = piper;
      servers = {
        default = {
          voice = "en_US-danny-low";
          uri = "tcp://0.0.0.0:10200";
          streaming = true;
          enable = true;
        };
      };
    };
    services.wyoming.faster-whisper = {
      servers = {
        default = {
          enable = true;
          model = "turbo";
          uri = "tcp://0.0.0.0:10300";
          language = "en";
          device = "cuda";
          useTransformers = false;
        };
      };
    };
    systemd.services.wyoming-piper-default = {
      serviceConfig = {
        ExecStart = lib.mkForce (
          utils.escapeSystemdExecArgs ([
            (lib.getExe piper)
            "--data-dir"
            "/var/lib/wyoming/piper"
            "--uri"
            "tcp://0.0.0.0:10200"
            "--use-cuda"
            "--voice"
            "en_US-danny-low"
            "--speaker"
            "0"
            "--length-scale"
            "1.000000"
            "--noise-scale"
            "0.667000"
            "--noise-w"
            "0.333000"
            "--streaming"
          ])
        );
        ProcSubset = lib.mkForce "all";
      };
    };
  });
}
