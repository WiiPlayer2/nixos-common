{ pkgs
, lib
, config
, ...
}:
{
  options.my.components.services = with lib; {
    ssh = {
      authorizedKeys = mkOption {
        description = "A set of authorized keys";
        type =
          with types;
          attrsOf (submodule {
            options = {
              key = mkOption {
                description = "The ssh key";
                type = types.str;
              };
            };
          });
        default = { };
      };
    };
  };
}
