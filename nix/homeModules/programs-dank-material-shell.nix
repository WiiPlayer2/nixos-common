_:
{
  lib,
  config,
  options,
  ...
}:
with lib;
let
  opt = options.programs.dank-material-shell;
  cfg = config.programs.dank-material-shell;
in
{
  options.programs.dank-material-shell = {
    managedSettings = {
      barConfigs = mkOption {
        type = with types; lazyAttrsOf opt.settings.type; # JSON
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.dank-material-shell.settings = {
      barConfigs = mapAttrsToList (id: v: v // { inherit id; }) cfg.managedSettings.barConfigs;
    };
  };
}
