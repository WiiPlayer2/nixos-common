{
  pkgs,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  pname = "tockler-appimage";
  version = "4.0.22";
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/MayGo/tockler/refs/tags/v${version}/electron/shared/img/icon/win/tockler_icon_big.png";
    hash = "sha256-/AnlwEdAoBI79Eh9nMCZ8SVxReInKB3Km0oHzzqy7YY=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Tockler (AppImage)";
    exec = "${pname} %U";
    icon = icon;
    categories = [ "Office" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/MayGo/tockler/releases/download/v${version}/Tockler-${version}.AppImage";
    hash = "sha256-9Qwp3hXbAxnI4aif6PlX0WbVeefP7L67WP5GNW8rqaI=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      xorg.xwininfo
    ];

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';
}
