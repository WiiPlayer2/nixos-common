import ../../../_lib/enabled.nix {
  oldConfigPath = [ "programs" ];
  newConfigPath = [ "environment" "programs" ];
  setPath = [ "programsSet" ];
}
