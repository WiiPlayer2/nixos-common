{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pulsemeeter
  ];

  services.pipewire.wireplumber = {
    extraConfig = {
      live-transcription = {
        "wireplumber.profiles".main = {
          "live-transcription.sink.transcription" = "required";
        };
        "wireplumber.components" = [
          {
            type = "pw-module";
            name = "libpipewire-module-loopback";
            provides = "live-transcription.sink.transcription";
            arguments = {
              "node.name" = "transcription";
              "node.description" = "Transcription";
              "audio.position" = [
                "FL"
                "FR"
              ];
              "capture.props" = {
                # "audio.position" = [ "FL" "FR" ];
                "media.class" = "Audio/Sink";
              };
              "playback.props" = {
                # "audio.position" = [ "FL" "FR" ];
                "node.passive" = true;
                "stream.dont-remix" = true;
              };
            };
          }
        ];
      };
    };
  };
}
