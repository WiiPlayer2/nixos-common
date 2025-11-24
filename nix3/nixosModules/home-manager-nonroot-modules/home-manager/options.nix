{ lib, options }:
with lib;
{
  nonRootModules = mkOption {
    inherit (options.home-manager.sharedModules) type default;
  };
}
