import ../../../_lib/enabled.nix {
  getNewConfig = x: x.home.services;
  setNewConfig = x: { home.services = x; };
  setAttrs = x: { servicesSet = x; };
  getOldConfig = x: x.services;
  setOldConfig = x: { services = x; };
}
