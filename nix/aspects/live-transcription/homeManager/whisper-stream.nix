{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  this-whisper-cpp = pkgs.whisper-cpp-vulkan;
  this-hf = pkgs.python312Packages.huggingface-hub;

  model-path = "/tmp";
  main-model = "large-v3-turbo-q5_0";
  vad-model = "ggml-silero-v6.2.0.bin";
  transcription-file = "/tmp/whisper_transcript.txt";

  download-models = pkgs.writeShellApplication {
    name = "whisper-cpp-models";
    runtimeInputs = with pkgs; [
      this-whisper-cpp
      this-hf
      gnugrep
    ];
    text = ''
      whisper-cpp-download-ggml-model ${main-model} ${model-path}
      # hf download --local-dir ${model-path} ggml-org/whisper-vad ggml-silero-v6.2.0.bin
    '';
  };
  run-whisper = pkgs.writeShellApplication {
    name = "whisper-stream-run";
    runtimeInputs = [
      this-whisper-cpp
    ];
    text = ''
      exec whisper-stream ${
        escapeShellArgs [
          "--translate"
          "--language"
          "auto"
          "--model"
          "${model-path}/ggml-${main-model}.bin"
          "--file"
          transcription-file
          "--step"
          "0"
          "--length"
          "30000"
        ]
      }
    '';
  };
in
{
  # TODO: add small service running whisper-stream with model download beforehand (or configure model path)
  # maybe also this: https://localai.io/features/openai-realtime/index.html
  home.packages = with pkgs; [
    # crispasr
    this-whisper-cpp
    this-hf
  ];

  systemd.user.services = {
    whisper-stream = {
      Service = {
        ExecStartPre = "${getExe download-models}";
        ExecStart = "${getExe run-whisper}";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
