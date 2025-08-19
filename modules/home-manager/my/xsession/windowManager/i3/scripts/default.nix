{ pkgs, ... }:
let
  loadScript = name: pkgs.writeScript name (builtins.readFile ./${name}.sh);
in
{
  workspace-buttons = loadScript "workspace-buttons";
  move-to-workspace-right = loadScript "move-to-workspace-right";
  move-to-workspace-left = loadScript "move-to-workspace-left";
}
