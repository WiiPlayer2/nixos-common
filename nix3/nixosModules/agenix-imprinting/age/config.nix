{ lib, config }:
with lib;
let
  cfg = config.age.imprinting;
in
mkIf cfg.enable {
  identityPaths = [
    cfg.target
  ];
}
