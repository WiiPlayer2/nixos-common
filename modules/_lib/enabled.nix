{ oldConfigPath
, newConfigPath
, setPath
,
}:
{ lib, config, options, ... }:
with lib;
let
  cfg = attrByPath newConfigPath null config;
in
{
  options =
    let
      newOption = setAttrByPath newConfigPath (mkOption {
        type = with types; listOf str;
        default = [ ];
      });
      setOption = setAttrByPath setPath (mkOption {
        type = with types; lazyAttrsOf str;
        readOnly = true;
      });
    in
    newOption // setOption;

  config =
    let
      newConfig = setAttrByPath newConfigPath (
        genAttrs
          cfg
          (_: { enable = true; })
      );

      setConfig = setAttrByPath setPath (
        mapAttrs
          (n: _: n)
          (attrByPath oldConfigPath null options)
      );
    in
    newConfig // setConfig;
}
