{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  writeTextFile,
}:
let
  pname = "transcription-appimage";
  version = "1.3.8";
  icon = fetchurl {
    url = "https://github.com/homelab-00/TranscriptionSuite/blob/99ad24d811cba5fee443af07a994745d1cd08d32/docs/assets/logo.png?raw=true";
    hash = "sha256-1OZ87X3q6s3ibyDq30WgUzvhyTLiqUMcrPuu5a4YRe0=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Transcription Suite (AppImage)";
    exec = "${pname} %U";
    icon = icon;
    categories = [
      "AudioVideo"
      "Audio"
      "Office"
      "Utility"
    ];
  };
  policy = writeTextFile {
    name = "transcription-appimage-fhs-container-policy";
    destination = "/etc/containers/policy.json";
    text = ''
      {
        "default": [
          {
            "type": "insecureAcceptAnything"
          }
        ],
        "transports":
          {
            "docker-daemon":
              {
                "": [{"type":"insecureAcceptAnything"}]
              }
          }
      }
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/homelab-00/TranscriptionSuite/releases/download/v${version}/TranscriptionSuite-${version}.AppImage";
    hash = "sha256-NZ1evOjIa6w/I1rWsR0DEz0JQenX2V/oADowCC3GRtg=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  extraPkgs = _: [
    # TODO: doesn't work T_T
    policy
  ];
}
