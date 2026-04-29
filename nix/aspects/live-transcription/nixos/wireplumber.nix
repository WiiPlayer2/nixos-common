{ pkgs, ... }:
let
  link-script = pkgs.writeShellApplication {
    name = "link-transcription-audio-nodes";
    runtimeInputs = with pkgs; [
      pipewire
    ];
    text = ''
      pw-link output.live-transcription.loopback.in.audio:output_FL input.live-transcription.loopback.mix:input_FL || echo "failed to connect Audio (In) -> Mix [L]"
      pw-link output.live-transcription.loopback.in.audio:output_FR input.live-transcription.loopback.mix:input_FR || echo "failed to connect Audio (In) -> Mix [R]"
      pw-link output.live-transcription.loopback.in.audio:output_FL input.live-transcription.loopback.out.audio:input_FL || echo "failed to connect Audio (In) -> Audio (Out) [L]"
      pw-link output.live-transcription.loopback.in.audio:output_FR input.live-transcription.loopback.out.audio:input_FR || echo "failed to connect Audio (In) -> Audio (Out) [R]"
      pw-link output.live-transcription.loopback.in.mic:output_FL input.live-transcription.loopback.mix:input_FL || echo "failed to connect Microphone -> Mix [L]"
      pw-link output.live-transcription.loopback.in.mic:output_FR input.live-transcription.loopback.mix:input_FR || echo "failed to connect Microphone -> Mix [R]"
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    pulsemeeter
    qpwgraph
    link-script
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
                autoConnectCapture ? false,
                autoConnectPlayback ? false,
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
                    "node.dont-reconnect" = !autoConnectCapture;
                    "node.autoconnect" = autoConnectCapture;
                    "media.class" = if showAsSpeaker then "Audio/Sink" else "Stream/Input/Audio";
                  };
                  "playback.props" = {
                    "stream.dont-remix" = true;
                    "node.passive" = true;
                    "node.dont-reconnect" = !autoConnectPlayback;
                    "node.autoconnect" = autoConnectPlayback;
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
              autoConnectCapture = true;
            })
            (mkLoopback {
              name = "live-transcription.loopback.out.audio";
              description = "Transcription (Audio Out)";
              autoConnectPlayback = true;
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
