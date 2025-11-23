{ lib, config, pkgs, super }:
with lib;
let
  cfg = config.age.imprinting;
  imprintingIdentityArg =
    if cfg.imprintingIdentityFile != null
    then "-i ${escapeShellArg "${super.imprintingPkg}/imprinting-identity"}"
    else "";
  pathEnv =
    if cfg.plugins != [ ]
    then "PATH=\"${makeBinPath cfg.plugins}:$PATH\""
    else "";
  targetArg = escapeShellArg cfg.target;
  imprintingFileArg =
    escapeShellArg "${super.imprintingPkg}/imprinting-file";
in
mkIf cfg.enable {
  agenixNewGeneration.deps = [ "agenixImprinting" ];

  agenixImprinting = {
    deps = [ "specialfs" ];
    text = ''
      if [ ! -f ${targetArg} ]; then
        echo "Imprinting ${targetArg}..."

        mkdir -p "$TMPDIR"
        if ! ${pathEnv} ${getExe pkgs.age} -d ${imprintingIdentityArg} -o ${targetArg} ${imprintingFileArg}; then
          echo "Imprinting failed. To retry ensure the target file does not exist when activating again."
          sleep 10
          _localstatus=1
        fi
      fi
    '';
  };
}
