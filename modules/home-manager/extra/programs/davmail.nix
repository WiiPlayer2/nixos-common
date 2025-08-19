{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.davmail;
in
{
  # TODO: add settings option to configure tokenFilePath
  options.programs.davmail = {
    enable = mkEnableOption "Whether davmail should be available.";
    package = mkOption {
      type = types.package;
      default = pkgs.davmail;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
