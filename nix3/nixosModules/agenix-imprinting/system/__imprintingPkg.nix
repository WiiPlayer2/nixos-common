{ config, pkgs }:
let
  cfg = config.age.imprinting;
in
pkgs.runCommand "imprinting-files" { } ''
  mkdir -p $out
  ln -sf ${cfg.imprintingFile} $out/imprinting-file
  ${
    if cfg.imprintingIdentityFile != null
    then ''
      ln -sf ${cfg.imprintingIdentityFile} $out/imprinting-identity
    ''
    else ""
  }
''
