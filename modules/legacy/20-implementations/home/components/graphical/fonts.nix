{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        # hachimarupop
        rounded-mgenplus
        wqy_zenhei
        unifont
      ];
    };
}
