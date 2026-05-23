{
  erosanixLib,
  requireFile,

  wine,
  wineWow64Packages,
}:
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
  inherit pname version src;
  inherit wine;
  # wine = wineWow64Packages.full;
  dontUnpack = true;
  enableMonoBootPrompt = true;
  wineArch = "win32";

  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${pname}
    runHook postInstall
  '';

  winAppInstall = ''
    echo "Installing dependencies..."
    winetricks --optout win11 dotnet48 vcrun2022 allfonts

    echo "Installing FUJIFILM PC AutoSave..."
    $WINE ${src} /S /v/qn
  '';

  winAppRun = ''
    # $WINE "$WINEPREFIX/drive_c/Program Files (x86)/FUJIFILM/FUJIFILM PC AutoSave/Manager.exe" "$ARGS"
    $WINE "$WINEPREFIX/drive_c/Program Files/FUJIFILM/FUJIFILM PC AutoSave/Manager.exe" "$ARGS"
  '';

  meta.mainProgram = pname;
}
