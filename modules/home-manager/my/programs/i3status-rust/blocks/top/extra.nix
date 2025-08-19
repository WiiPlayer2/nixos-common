{ pkgs
, lib
, config
, ...
}:
with lib;
let
  cfg = config.my.components.graphical.windowManager.i3.extraBlocks;
  mapItem = item: mkIf item.enable item.block;
  filteredItems = filter (x: x.value.bar == "top") (attrsToList cfg);
  mappedItems = map (x: mapItem x.value) filteredItems;
in
mappedItems
