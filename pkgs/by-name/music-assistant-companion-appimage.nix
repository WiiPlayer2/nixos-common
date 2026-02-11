{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  pname = "music-assistant-companion-appimage";
  version = "0.3.4";
  icon = fetchurl {
    url = "https://github.com/music-assistant/desktop-companion/blob/d005a1be801e569c1c854fc923e89f58727d901f/app-icon.png?raw=true";
    hash = "sha256-fC0gm54cmla5ut3sqcK58Jp4bpR80eglvj1jtyfvvL4=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Music Assistant Companion (AppImage)";
    exec = "${pname} %U";
    icon = icon;
    categories = [
      "AudioVideo"
      "Audio"
    ];
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/music-assistant/desktop-app/releases/download/${version}/Music.Assistant_${version}_amd64.AppImage";
    hash = "sha256-dcghuI5aEgqS9R6mPwLAQTl4+00mmzhDZZF2+IU6hzk=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';
}
