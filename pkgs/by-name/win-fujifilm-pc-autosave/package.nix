{
  lib,
  erosanixLib,
  requireFile,
  fetchurl,

  wine,
  wineWow64Packages,
  makeDesktopItem,
  copyDesktopItems,
}:
with lib;
let
  pname = "win-FUJIFILM-PC-AutoSave";
  version = "1.3.1.0";
  src = requireFile {
    name = "PCAutoSaveSetup.exe";
    url = "https://www.fujifilm-x.com/global/support/download/software/pc-autosave/#windows";
    sha256 = "1ms1fd2j6sirq1c6s6cm876ywlqk4cx2l5m51jjvb5v73jvsc8rv";
  };
in
erosanixLib.mkWindowsAppNoCC {
  inherit
    pname
    version
    src
    wine
    ;
  dontUnpack = true;
  enableMonoBootPrompt = true;
  wineArch = "win32";

  nativeBuildInputs = [
    copyDesktopItems
    erosanixLib.copyDesktopIcons
  ];

  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${pname}
    runHook postInstall
  '';

  winAppInstall = ''
    winetricks --optout --unattended dotnet48
    $WINE ${src} /S /v/qn
    wineserver -k
    wineserver -w
  '';

  winAppRun = ''
    $WINE "$WINEPREFIX/drive_c/Program Files/FUJIFILM/FUJIFILM PC AutoSave/Manager.exe" "$ARGS"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "FUJIFILM PC AutoSave";
      comment = "Automatically sync photos from camera";
      categories = [
        "Office"
        "Photography"
      ];
    })
  ];

  desktopIcon = erosanixLib.makeDesktopIcon {
    name = pname;
    icoIndex = 0;
    src = ./fujifilm_pc_autosave.ico;
  };

  meta.mainProgram = pname;
}
