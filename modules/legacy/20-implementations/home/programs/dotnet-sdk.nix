{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.dotnet-sdk;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (
        with dotnetCorePackages;
        combinePackages [
          sdk_8_0
          sdk_9_0
          sdk_10_0 # still rc
        ]
      )
    ];
  };
}
