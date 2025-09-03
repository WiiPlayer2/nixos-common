import ../../../_lib/enabled.nix {
  oldConfigPath = [ "services" ];
  newConfigPath = [ "home" "services" ];
  setPath = [ "servicesSet" ];
}
