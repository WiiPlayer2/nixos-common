{ lib, config }:
with lib;
let
  cfg = config.home-manager;

  transformModule =
    module:
    { lib, config, ... } @ args:
    let
      moduleConfig =
        if isFunction module
        then module args
        else module;
    in
    mkIf (config.home.username != "root") moduleConfig;
in
{
  sharedModules =
    map
      transformModule
      cfg.nonRootModules;
}
