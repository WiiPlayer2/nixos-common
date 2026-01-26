{
  lib,
  config,
  pkgs,
  super,
}:
with lib;
let
  cfg = config.age.imprinting;
  imprintingIdentityArg =
    if cfg.imprintingIdentityFile != null then
      "-i ${escapeShellArg "${super.imprintingPkg}/imprinting-identity"}"
    else
      "";
  targetArg = escapeShellArg cfg.target;
  imprintingFileArg = escapeShellArg "${super.imprintingPkg}/imprinting-file";
in
mkIf cfg.enable [
  (pkgs.writeShellApplication {
    name = "imprint-age-secret";
    runtimeInputs = cfg.plugins;
    text = ''
      if [ -f ${targetArg} ]; then
        echo "Target file ${targetArg} already exists. Delete it first to imprint file."
        exit 1
      fi

      if ! ${getExe pkgs.age} -d ${imprintingIdentityArg} -o ${targetArg} ${imprintingFileArg}; then
        echo "Imprinting failed. To retry ensure the target file does not exist when activating again."
        exit 1
      fi

      chmod 400 ${targetArg}
      echo "${targetArg} successfully imprinted."
    '';
  })
]
