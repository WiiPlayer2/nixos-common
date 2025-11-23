{ lib, config, pkgs }:
with lib;
let
  cfg = config.age.imprinting;
in
mkIf cfg.enable {
  agenixNewGeneration.deps = [ "agenixImprinting" ];

  agenixImprinting = {
    deps = [ "specialfs" ];
    text = ''
      if [ ! -f ${cfg.target}" ]; then
        echo "Imprinting \"${cfg.target}\"..."

        if ! PATH="${makeBinPath (cfg.plugins ++ ["$PATH"])}" ${getExe pkgs.age} -d ${if cfg.imprintingIdentityFile != null then "-i ${escapeShellArg cfg.imprintingIdentityFile}" else ""} -o ${escapeShellArg cfg.target} ${escapeShellArg cfg.imprintingFile}; then
          echo "Imprinting failed. To retry ensure the target file does not exist when activating again."
          sleep 10
        fi
      fi
    '';
  };
}
