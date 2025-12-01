{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  pname = "overlayed-appimage";
  version = "0.6.2";
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/overlayeddev/overlayed/v${version}/apps/desktop/public/img/icon.png";
    hash = "sha256-EJ0racfjzHj11CA5/0BXX/JQP3H5LNUQPKxPgaxcC3g=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Overlayed (AppImage)";
    exec = "${pname} %U";
    icon = icon;
    categories = [ "Development" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/overlayeddev/overlayed/releases/download/v${version}/Overlayed_${version}_amd64.AppImage";
    hash = "sha256-KflY0XzHIeznUZJ616xnvKxgo9Nfm0kkka1uL5w1XXg=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';
}
