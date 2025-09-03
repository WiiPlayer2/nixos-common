import ../../../_lib/enabled.nix {
  getNewConfig = x: x.environment.services;
  setNewConfig = x: { environment.services = x; };
  setAttrs = x: { servicesSet = x; };
  getOldConfig = x: x.services;
  setOldConfig = x: { services = x; };
}
