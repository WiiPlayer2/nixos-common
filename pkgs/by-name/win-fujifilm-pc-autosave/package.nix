{
  erosanixLib,
  requireFile,

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
  wine = wineWow64Packages.full;
  dontUnpack = true;
  enableMonoBootPrompt = false;
  wineArch = "win64";

  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${pname}
    runHook postInstall
  '';

  winAppInstall = ''
    winetricks --optout win11
    winetricks --optout dotnet48
    $WINE ${src} /S /v/qn
  '';

  winAppRun = ''
    $WINE "$WINEPREFIX/drive_c/Program Files (x86)/FUJIFILM/FUJIFILM PC AutoSave/Manager.exe" "$ARGS"
  '';

  meta.mainProgram = pname;
}
