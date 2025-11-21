{ lib, config, pkgs }:
with lib;
let
  cfg = config.programs.bizhawk;

  wrappedFiles =
    pkg:
    pkgs.runCommand "wrapped-files-${pkg.name}" { } ''
      mkdir -p $out/bin
      for bin in ${pkg}/bin/*; do
        _name=$(basename "$bin")
        _source="${pkg}/bin/$_name"
        _target="$out/bin/$_name"

        cat << EOF > "$_target"
      #!${pkgs.runtimeShell}
      set -euo pipefail

      exec ${cfg.prefixCommand} "$_source" "\$@"
      EOF

        chmod +x "$_target"
      done
    '';
  wrappedPackage =
    pkg:
    pkgs.buildEnv {
      name = "wrapped-${pkg.name}";
      ignoreCollisions = true;
      paths = [
        (wrappedFiles pkg)
        pkg
      ];
    };
  wrapPackageIfNeeded =
    pkg:
    if cfg.prefixCommand == null
    then pkg
    else wrappedPackage pkg;
in
mkIf cfg.enable {
  packages = [
    (wrapPackageIfNeeded cfg.package)
  ];
}
