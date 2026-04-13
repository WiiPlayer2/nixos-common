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
    whisper-cpp
    python312Packages.huggingface-hub
  ];
}
