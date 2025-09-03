import ../../../_lib/enabled.nix {
  getNewConfig = x: x.home.programs;
  setNewConfig = x: { home.programs = x; };
  setAttrs = x: { programsSet = x; };
  getOldConfig = x: x.programs;
  setOldConfig = x: { programs = x; };
}
