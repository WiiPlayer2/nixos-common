{ lib, config, pkgs }:
with lib;
let
  cfg = config.programs.dolphin-emu;

  environmentVariableScript =
    join
      "\n"
      (
        map
          ({ name, value }: "export ${name}=${escapeShellArg value}")
          (attrsToList cfg.prefixEnvironmentVariables)
      );

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

      ${environmentVariableScript}
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
  allVariants =
    map
      wrapPackageIfNeeded
      ([ cfg.package ] ++ cfg.additionalVariants);
  package =
    if length allVariants == 1
    then elemAt allVariants 0
    else
      pkgs.buildEnv {
        name = join "-and-" (map (x: x.name) allVariants);
        ignoreCollisions = true;
        paths = allVariants;
      };
in
mkIf cfg.enable {
  packages = [
    package
  ];
}
