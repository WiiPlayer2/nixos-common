{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  pname = "transcription-appimage";
  version = "1.3.4";
  # icon = fetchurl {
  #   url = "https://github.com/music-assistant/desktop-companion/blob/d005a1be801e569c1c854fc923e89f58727d901f/app-icon.png?raw=true";
  #   hash = "sha256-fC0gm54cmla5ut3sqcK58Jp4bpR80eglvj1jtyfvvL4=";
  # };
  # desktopItem = makeDesktopItem {
  #   name = pname;
  #   desktopName = "Music Assistant Companion (AppImage)";
  #   exec = "${pname} %U";
  #   icon = icon;
  #   categories = [
  #     "AudioVideo"
  #     "Audio"
  #   ];
  # };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com//homelab-00/TranscriptionSuite/releases/download/v${version}/TranscriptionSuite-${version}.AppImage";
    hash = "sha256-+4f95VR+DnPyjXzkLf/LSz2fD4BQQvrJJICZDK4QM1A=";
  };

  # extraInstallCommands = ''
  #   mkdir -p "$out/share"
  #   ln -s "${desktopItem}/share/applications" "$out/share/"
  # '';
}
