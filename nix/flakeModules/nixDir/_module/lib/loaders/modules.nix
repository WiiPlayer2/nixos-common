{
  lib,
  import-tree,
  inputs,
}:
with lib;
{ }:
let
  args = {
    inherit lib inputs;
  };
in
{
  loadByAttribute = true;

  loader =
    { path, ... }:
    let
      fileModule' = path: import path args;
      fileModule = fileModule' path;
      # TODO: use import tree for whole module and import specific files (in this case `module.nix`) using import args
      directoryModule =
        let
          fileModule =
            let
              filePath = path + /module.nix;
              module = setDefaultModuleLocation filePath (fileModule' filePath);
            in
            optional (pathIsRegularFile filePath) module;
          treeModule =
            let
              treePath = path;
              module = pipe import-tree [
                (i: i.filter (x: x != "/module.nix"))
                (i: i treePath)
              ];
            in
            optional (pathIsDirectory treePath) module;
        in
        {
          imports = fileModule ++ treeModule;
        };
      module = if pathIsRegularFile path then fileModule else directoryModule;
    in
    setDefaultModuleLocation path module;
}
