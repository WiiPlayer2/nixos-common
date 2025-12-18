{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
with lib;
let
  cfg = config.nixDir4;
  nixDirLib = cfg.lib;

  first = ls: elemAt ls 0;
in
{
  imports = [
    (inputs.import-tree ./loaders)
  ];

  options.nixDir4 = {
    lib = mkOption {
      type = types.raw;
      readOnly = true;
      default = inputs.haumea.lib.load {
        src = ./lib;
        inputs = {
          inherit config inputs withSystem;
          lib = extend (_: _: inputs.haumea.lib);
        };
      };
    };

    root = mkOption {
      type = types.path;
    };

    src = mkOption {
      type = types.path;
      default = cfg.root + /nix4;
    };

    loaders = mkOption {
      type = types.submoduleWith {
        modules = [
          {
            freeformType = types.lazyAttrsOf nixDirLib.types.loader;
            # options = {
            #   perSystem = mkOption {
            #     type = types.lazyAttrsOf nixDirLib.types.perSystemLoader;
            #     default = { };
            #   };
            # };
          }
        ];
      };
      default = { };
    };
  };

  config.flake =
    let
      loaderPathResult =
        loadCfg: path:
        let
          srcFor =
            subPath:
            let
              srcDir = cfg.src + "/${subPath}";
              srcDirExists = pathIsDirectory srcDir;
              srcFile = cfg.src + "/${subPath}.nix";
              srcFileExists = pathIsRegularFile srcFile;
            in
            assert assertMsg (
              !(srcFileExists && srcDirExists)
            ) "${srcDir} and ${srcFile} can't exist simultaneously.";
            if srcDirExists then
              srcDir
            else if srcFileExists then
              srcFile
            else
              null;

          attributeSources =
            let
              baseSrc = cfg.src + "/${path}"; # must be a directory
              subSrcs =
                let
                  entries = builtins.readDir baseSrc;

                  candidates = filterAttrs (n: v: v != "file" || hasSuffix ".nix" n) entries;

                  paths = uniqueStrings (map (removeSuffix ".nix") (attrNames candidates));
                in
                genAttrs paths (x: srcFor "${path}/${x}");
            in
            assert assertMsg (pathExists baseSrc -> pathIsDirectory baseSrc) "${baseSrc} must be a directory.";
            if pathExists baseSrc then subSrcs else { };

          loadResultByAttribute = filterAttrs (_: v: v != { }) (
            mapAttrs (n: path: loadCfg.loader { inherit path; }) attributeSources
          );

          loadResult =
            if loadCfg._isPerSystem then
              throw "TODO"
            else if loadCfg.loadByAttribute then
              loadResultByAttribute
            else
              throw "TODO";
        in
        if loadResult != { } then
          {
            ${loadCfg.target} = loadResult;
          }
        else
          { };

      loaderResult = loadCfg: mergeAttrsList (map (loaderPathResult loadCfg) loadCfg.paths);

      result = mergeAttrsList (
        map loaderResult (
          # (attrValues (removeAttrs cfg.loaders [ "perSystem" ])) ++ (attrValues cfg.loaders.perSystem)
          (attrValues (removeAttrs cfg.loaders [ "perSystem" ]))
        )
      );
    in
    result;
}
