{
  getNewConfig,
  setNewConfig,
  setAttrs,
  getOldConfig,
  setOldConfig,
}:
{
  lib,
  config,
  options,
  ...
}:
with lib;
let
  cfg = getNewConfig config;
in
{
  options =
    let
      newOption = setNewConfig (mkOption {
        type = with types; listOf str;
        default = [ ];
      });
      setOption = setAttrs (mkOption {
        type = with types; lazyAttrsOf str;
        readOnly = true;
      });
    in
    newOption // setOption;

  config =
    let
      oldConfig = setOldConfig (
        genAttrs cfg (_: {
          enable = true;
        })
      );

      setConfig = setAttrs (mapAttrs (n: _: n) (getOldConfig options));
    in
    oldConfig // setConfig;
}
