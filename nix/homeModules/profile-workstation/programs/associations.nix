{ lib, ... }:
with lib;
let
  transpose =
    attrsOfList:
    let
      desktopMimeTypes =
        n: v:
        map (x: {
          desktop = n;
          scheme = x;
        }) (toList v);

      allAssociations = concatMap ({ name, value }: desktopMimeTypes name value) (
        attrsToList attrsOfList
      );

      combine =
        acc:
        { scheme, desktop }:
        acc
        // {
          ${scheme} = acc.${scheme} or [ ] ++ [ desktop ];
        };
    in
    foldl combine { } (allAssociations);
in
{
  # This should be done by the respective programs
  xdg.mimeApps = {
    enable = true;

    defaultApplications = transpose {
      "firefox.desktop" = [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      "signal.desktop" = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
      "Logseq.desktop" = "x-scheme-handler/logseq";
    };
  };
}
