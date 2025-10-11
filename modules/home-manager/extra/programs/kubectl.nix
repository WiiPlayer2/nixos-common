{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.kubectl;
in
{
  options.programs.kubectl = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "kubectl" { };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
