{ pkgs
, appimageTools
, fetchurl
, makeDesktopItem
}:
let
  pname = "freelens-appimage";
  version = "1.5.3";
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/freelensapp/freelens/v${version}/freelens/build/icons/512x512.png";
    hash = "sha256-YgugB0dJrr/fFwA9H8E0Oc3hhyvFIolR+RetXR01Y7Y=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Freelens (AppImage)";
    exec = "${pname} %U";
    icon = icon;
    categories = [ "Development" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
    hash = "sha256-I6jmMGCkkdZPJoLNGfWhUc5SAjNcRzPJsVckxZ6eeng=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';
}
