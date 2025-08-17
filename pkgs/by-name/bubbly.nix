{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, eww
, xorg
, dash
,
}:
let
  inherit (lib)
    replaceStrings
    concatStringsSep
    map
    ;
in
stdenv.mkDerivation (final: {
  pname = "bubbly";
  version = "0-unstable-2025-01-03";

  src = fetchFromGitHub {
    owner = "siduck";
    repo = "bubbly";
    rev = "3254e943831e2fb25bbdcaffc404ed36cf232c00";
    hash = "sha256-DvJ7h7hmIXuf+0TPzYZnamcSugIDhCGHpcW/D1zgEGQ=";
  };

  buildInputs = [
    eww
    xorg.xinput
    dash
  ];

  installPhase =
    let
      files = [
        "start.sh"
        "bubbles/scripts/getkeys.sh"
        "keystrokes/scripts/getkeys.sh"
        "selector/scripts/switchMode.sh"
      ];
      sedEww =
        let
          ewwPath = "${eww}";
          fixedEwwPath = replaceStrings [ "/" ] [ "\\/" ] ewwPath;
        in
        file: "sed -i 's/eww/${fixedEwwPath}\\/bin\\/eww/g' $out/share/bubbly/${file}";
      sedFiles = sedMap: concatStringsSep "\n" (map sedMap files);
    in
    ''
      mkdir -p $out/{bin,share}
      cp -r . $out/share/bubbly
      ln -s $out/share/bubbly/start.sh $out/bin/bubbly
      ln -s $out/share/bubbly/selector/scripts/switchMode.sh $out/bin/bubbly-switch-mode

      SED_OUT=$(echo $out | sed -r 's/\//\\\//g')
      SED_CODE="s/basedir=\"\$HOME\/.local\/share\/bubbly\"/basedir=\"$SED_OUT\/share\/bubbly\"/"
      sed -i "$SED_CODE" $out/share/bubbly/start.sh
      sed -i "$SED_CODE" $out/share/bubbly/bubbles/scripts/getkeys.sh
      sed -i "$SED_CODE" $out/share/bubbly/keystrokes/scripts/getkeys.sh
      sed -i "$SED_CODE" $out/share/bubbly/selector/scripts/switchMode.sh
      ${sedFiles sedEww}
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
})
