{ lib, config, options, ... }:
with lib;
let
  cfg = config.home.programs;
in
{
  options = {
    home.programs = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    programsSet = mkOption {
      type = with types; lazyAttrsOf str;
      readOnly = true;
    };
  };

  config = {
    programs =
      let
        enabledProgram = { enable = true; };
        enabledPrograms =
          genAttrs
            cfg
            (_: enabledProgram);
      in
      enabledPrograms;

    programsSet =
      mapAttrs
        (n: _: n)
        options.programs;
  };
}
