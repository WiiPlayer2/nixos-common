{ lib, config, ... }:
with lib;
let
  c = mkOption { type = types.attrs; };
in
{
  options.stylix = c;
}
