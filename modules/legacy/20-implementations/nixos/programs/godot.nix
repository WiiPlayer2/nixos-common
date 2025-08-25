{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.godot;
in
{
  config = mkIf cfg.enable {
    my.meta.allowedInsecurePackages = [
      "dotnet-sdk-6.0.428"
    ];
  };
}
