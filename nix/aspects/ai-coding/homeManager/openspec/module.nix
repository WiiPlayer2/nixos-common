{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkOptionDefault
    types
    mkIf
    ;

  cfg = config.programs.openspec;

  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  options.programs.openspec = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "openspec" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
    };

    settingsFile = mkOption {
      type = types.path;
      default = settingsFile;
    };

    schemas = mkOption {
      type = types.lazyAttrsOf (
        types.submodule ({
          options = {
            source = mkOption {
              type = types.path;
            };
          };
        })
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg = {
      configFile."openspec/config.json".source = cfg.settingsFile;
      dataFile =
        let
          mkSchemaFile = name: schemaCfg: {
            name = "openspec/schemas/${name}";
            value.source = schemaCfg.source;
          };
          schemaFiles = lib.mapAttrs' mkSchemaFile cfg.schemas;
        in
        schemaFiles;
    };

    # TODO: official default values
    programs.openspec.settings = {
      telemetry.enabled = mkOptionDefault false;
      completionTipSeen = mkOptionDefault true;
    };
  };
}
