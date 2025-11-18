{ lib, config, super }:
with lib;
let
  cfg = config.programs.archipelago;

  worldFiles =
    mergeAttrsList
      (
        map
          (world: {
            "Archipelago/worlds/${world.name}".source = world;
          })
          cfg.worlds
      );
in
mkIf cfg.enable {
  packages = [
    cfg.package
  ];

  file = worldFiles;
}
