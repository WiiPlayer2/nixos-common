{ lib, config, super }:
with lib;
let
  cfg = config.programs.archipelago;

  worldFiles =
    mergeAttrsList
      (
        map
          (world: {
            ".local/share/Archipelago/worlds/${world.meta.name}.apworld" = {
              source = "${world}/${world.meta.name}.apworld";
            };
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
