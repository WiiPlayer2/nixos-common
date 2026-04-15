{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pulsemeeter
    qpwgraph
  ];

  # TODO: internal connections should be configured/scripted
  /*
    communication app               hardware microphone
            |                               |
            v                               v
      transcription-in-audio          transcription-in-mic
            |      |                      |
            |      +-----------------+    |
            |                        |    |
            v                        v    v
      transcription-out-audio      transcription-mix
            |                       |
            v                       v
        hardware speaker          transcription app
  */

  services.pipewire.wireplumber = {
    extraConfig = {
      live-transcription = {
        "wireplumber.profiles".main = {
          "live-transcription.loopback.in.audio" = "required";
          "live-transcription.loopback.in.mic" = "required";
          "live-transcription.loopback.out.audio" = "required";
          "live-transcription.loopback.mix" = "required";
        };
        "wireplumber.components" =
          let
            mkLoopback =
              {
                name,
                description,
                showAsSpeaker ? false,
                showAsMicrophone ? false,
              }:
              {
                type = "pw-module";
                name = "libpipewire-module-loopback";
                provides = name;
                arguments = {
                  "node.name" = name;
                  "node.description" = description;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "capture.props" = {
                    "stream.dont-remix" = true;
                    "node.passive" = true;
                    "node.dont-reconnect" = true;
                    "node.autoconnect" = false;
                    "media.class" = if showAsSpeaker then "Audio/Sink" else "Stream/Input/Audio";
                  };
                  "playback.props" = {
                    "stream.dont-remix" = true;
                    "node.passive" = true;
                    "node.dont-reconnect" = true;
                    "node.autoconnect" = false;
                    "media.class" = if showAsMicrophone then "Audio/Source" else "Stream/Output/Audio";
                  };
                };
              };
          in
          [
            (mkLoopback {
              name = "live-transcription.loopback.in.audio";
              description = "Transcription (Audio In)";
              showAsSpeaker = true;
            })
            (mkLoopback {
              name = "live-transcription.loopback.in.mic";
              description = "Transcription (Mic In)";
            })
            (mkLoopback {
              name = "live-transcription.loopback.out.audio";
              description = "Transcription (Audio Out)";
            })
            (mkLoopback {
              name = "live-transcription.loopback.mix";
              description = "Transcription (Mix)";
              showAsMicrophone = true;
            })
          ];
      };
    };
  };
}
