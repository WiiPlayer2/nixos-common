{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.attic-client;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      attic-client

      (writeShellScriptBin "attic-post-build-hook" ''
        set -e
        ${attic-client}/bin/attic push $1 $OUT_PATHS
      '')
    ];
  };
}
