import ../../../_lib/enabled.nix {
  oldConfigPath = [ "services" ];
  newConfigPath = [ "environment" "services" ];
  setPath = [ "servicesSet" ];
}
