import ../../../_lib/enabled.nix {
  getNewConfig = x: x.environment.programs;
  setNewConfig = x: { environment.programs = x; };
  setAttrs = x: { programsSet = x; };
  getOldConfig = x: x.programs;
  setOldConfig = x: { programs = x; };
}
