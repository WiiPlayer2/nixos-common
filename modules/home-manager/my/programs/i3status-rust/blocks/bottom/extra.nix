{ pkgs
, lib
, config
, ...
}:
with lib;
let
  cfg = config.my.components.graphical.windowManager.i3.extraBlocks;
  mappedItems = map (x: x.value.block) (
    sortOn (x: x.value.order) (filter (x: x.value.enable && x.value.bar == "bottom") (attrsToList cfg))
  );
in
mappedItems
