_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  # TODO: add small service running whisper-stream with model download beforehand (or configure model path)
  # maybe also this: https://localai.io/features/openai-realtime/index.html
  home.packages = with pkgs; [
    # crispasr
    whisper-cpp-vulkan
    python312Packages.huggingface-hub
  ];

  systemd.user.services = {
    whisper-stream = {
      Service = {
        Environment = [
          "PATH=${
            makeBinPath (
              with pkgs;
              [
                gnugrep
              ]
            )
          }"
        ];
        ExecStartPre = "${getExe' pkgs.whisper-cpp-vulkan "whisper-cpp-download-ggml-model"} base-q5_1 /tmp";
        ExecStart = "${getExe' pkgs.whisper-cpp-vulkan "whisper-stream"} --translate --language de --model /tmp/ggml-base-q5_1.bin --file /tmp/whisper-cpp-transcription.txt";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
