{
  lib,
  config,
  super,
}:
with lib;
let
  cfg = config.programs.poptracker;

  packsFiles = mergeAttrsList (
    map (pack: {
      "PopTracker/packs/${pack.name}".source = pack;
    }) (cfg.packs super.packs)
  );
in
mkIf cfg.enable {
  packages = [
    cfg.package
  ];

  file = packsFiles;
}
