{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages =
    with lib;
    let
      staticScriptDirectory = ./static;
      staticScriptFiles = filter (x: x.value == "regular" && x.name != "default.nix") (
        attrsToList (builtins.readDir staticScriptDirectory)
      );
      mapStaticToPkg =
        { name, ... }: pkgs.writeScriptBin name (readFile (staticScriptDirectory + "/${name}"));
      staticScriptPkgs = map mapStaticToPkg staticScriptFiles;

      dynamicScriptDirectory = ./dynamic;
      dynamicScriptFiles = filter (x: x.value == "regular" && x.name != "default.nix") (
        attrsToList (builtins.readDir dynamicScriptDirectory)
      );
      mapDynamicToPkgs =
        { name, ... }: pkgs.callPackage (dynamicScriptDirectory + "/${name}") { inherit config; };
      dynamicScriptPkgs = map mapDynamicToPkgs dynamicScriptFiles;

      scriptPkgs = staticScriptPkgs ++ dynamicScriptPkgs;
    in
    scriptPkgs;
}
