{ pkgs, ... }:
{
  services.voxtype = {
    enable = true;
    package = pkgs.voxtype-vulkan;
    settings = {
      hotkey = {
        enabled = false;
      };
      audio.feedback = {
        enabled = true;
      };
      whisper = {
        model = "base";
        language = [
          "de"
          "en"
        ];
        gpu_isolation = true;
      };
    };
    loadModels = [
      "base"
    ];
  };
}
