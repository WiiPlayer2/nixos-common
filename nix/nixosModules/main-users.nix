{ ... }:
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    genAttrs
    ;
  cfg = config.darklink.mainUsers;
in
{
  options.darklink.mainUsers = {
    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    homeModules = mkOption {
      type = options.home-manager.sharedModules.type;
      default = [ ];
    };

    userModule = mkOption {
      type = options.users.users.type.nestedTypes.elemType;
      default = { };
    };
  };

  config = {
    users.users = genAttrs cfg.users (_: cfg.userModule);
    home-manager.users = genAttrs cfg.users (_: {
      imports = cfg.homeModules;
    });
  };
}
