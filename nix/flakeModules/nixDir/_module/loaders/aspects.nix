{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with config.nixDir.lib;
let
  args = {
    inherit lib inputs;
  };
in
{
  nixDir.loaders.aspects = {
    loadByAttribute = true;
    loader =
      { path, ... }:
      let
        fileModule' = path: import path args;
        fileModule = fileModule' path;
        # TODO: use import tree for whole module and import specific files (in this case `module.nix`) using import args
        directoryModule =
          let
            submoduleNames = [
              "nixos"
              "homeManager"
            ];
            submodulesPath = x: path + "/${x}";
            submodule =
              x:
              let
                dirpath = submodulesPath x;
                filepath = (submodulesPath x) + ".nix";
              in
              if pathIsRegularFile filepath then
                loaders.modules { path = filepath; }
              else if pathIsDirectory dirpath then
                loaders.modules { path = dirpath; }
              else
                null;
            rawSubmodules = genAttrs submoduleNames submodule;
            submodules = filterAttrs (n: v: v != null) rawSubmodules;
          in
          submodules;
        module = if pathIsRegularFile path then fileModule else directoryModule;
      in
      module;
  };
}
