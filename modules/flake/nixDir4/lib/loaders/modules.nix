{ lib, inputs }:
with lib;
{
# extraInputs ? [ ],
}:
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
      directoryModule =
        let
          fileModule =
            let
              filePath = path + /module.nix;
              module = setDefaultModuleLocation filePath (fileModule' filePath);
            in
            optional (pathIsFile filePath) module;
          treeModule =
            let
              treePath = path + /tree;
              module = inputs.import-tree treePath;
            in
            optional (pathIsDirectory treePath) module;
        in
        {
          imports = fileModule ++ treeModule;
        };
      module = if pathIsFile path then fileModule else directoryModule;
    in
    setDefaultModuleLocation path module;
}
