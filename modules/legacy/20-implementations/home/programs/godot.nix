{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.godot;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      godot-mono
    ];
  };
}
