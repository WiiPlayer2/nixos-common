{
  lib,
  erosanixLib,
  requireFile,
  fetchurl,

  wine,
  wineWow64Packages,
  makeDesktopItem,
  copyDesktopItems,

  unzip,
}:
with lib;
let
  pname = "win-8BitDo-Ultimate-Software-V2";
  version = "1.34";
  src = fetchurl {
    url = "https://support.8bitdo.com/bd-uploads/files/ultimate_soft/8BitDo_Ultimate_Software_V2_Windows_V1.34.zip";
    hash = "sha256-yZ4OEwPHc8mwJgKpvLXNSQ1pKGMoK67dBv0toOvVuQA=";
  };
in
erosanixLib.mkWindowsAppNoCC {
  inherit
    pname
    version
    src
    wine
    ;
  enableMonoBootPrompt = false;
  # wineArch = "win32";

  nativeBuildInputs = [
    unzip
    copyDesktopItems
  ];

  installPhase = ''
    mkdir -p $out/lib/share/8bitdo-ultimate-v2

    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${pname}
    cp -r . $out/lib/share/8bitdo-ultimate-v2/
    chmod -R +x $out/lib/share/8bitdo-ultimate-v2/
    runHook postInstall
  '';

  winAppInstall = ''
    winetricks --optout --unattended corefonts

    mkdir -p $WINEPREFIX/opt
    cp -r $OUT_PATH/lib/share/8bitdo-ultimate-v2/. $WINEPREFIX/opt/
    chmod -R +w $WINEPREFIX/opt/
  '';

  winAppRun = ''
    cd $WINEPREFIX/opt
    $WINE "$WINEPREFIX/opt/8BitDo Ultimate Software V2.exe" "$ARGS"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      # icon = pname;
      desktopName = "8BitDo Ultimate Software V2";
      comment = "A one-stop solution for your 8BitDo devices";
      categories = [
        "Game"
      ];
    })
  ];

  meta.mainProgram = pname;
}
