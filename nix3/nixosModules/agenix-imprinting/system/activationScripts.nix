{ lib, config, pkgs }:
with lib;
let
  cfg = config.age.imprinting;
  imprintingIdentityArg =
    if cfg.imprintingIdentityFile != null
    then "-i ${escapeShellArg cfg.imprintingIdentityFile}"
    else "";
  pathEnv =
    if cfg.plugins != [ ]
    then "PATH=\"${makeBinPath cfg.plugins}:$PATH\""
    else "";
in
mkIf cfg.enable {
  agenixNewGeneration.deps = [ "agenixImprinting" ];

  agenixImprinting = {
    deps = [ "specialfs" ];
    text = ''
      if [ ! -f ${cfg.target}" ]; then
        echo "Imprinting \"${cfg.target}\"..."

        if ! ${pathEnv} ${getExe pkgs.age} -d ${imprintingIdentityArg} -o ${escapeShellArg cfg.target} ${escapeShellArg cfg.imprintingFile}; then
          echo "Imprinting failed. To retry ensure the target file does not exist when activating again."
          sleep 10
          _localstatus=1
        fi
      fi
    '';
  };
}
