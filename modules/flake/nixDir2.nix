{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir2;
in
{
  options.nixDir2 = {
    root = mkOption {
      type = types.path;
    };

    src = mkOption {
      type = types.path;
      default = cfg.root + /nix2;
    };

    loaders = mkOption {
      type = types.attrsOf (types.submodule (
        { config, ... }:
        {
          options = {
            pathNames = mkOption {
              type = types.listOf types.str;
            };

            loader = mkOption {
              type = types.functionTo types.anything;
            };
          };

          config = {
            pathNames = [
              config._module.args.name
            ];
          };
        }
      ));
      default = { };
    };
  };

  config = {
    nixDir2.loaders = {
      devShells.loader =
        path:
        let
          perSystem =
            fn:
            genAttrs
              config.systems
              (system: fn inputs.nixpkgs.legacyPackages.${system});

          loadPackages =
            pkgs:
            let
              args =
                let
                  rootConfig = config;
                in
                withSystem
                  pkgs.system
                  ({ inputs', config, ... }:
                    {
                      inherit pkgs inputs inputs';
                      config = rootConfig;
                      config' = config;
                    });
              packages = pkgs.lib.packagesFromDirectoryRecursive {
                callPackage = pkgs.lib.callPackageWith (pkgs // args // packages);
                directory = path;
              };
            in
            packages;
        in
        perSystem loadPackages;
    };

    flake =
      let
        loadPathName =
          loader:
          pathName:
          let
            path = cfg.src + "/${pathName}";
            exists = pathExists path;
            value = loader path;
            result = optionalAttrs exists value;
          in
          result;

        load =
          { pathNames
          , loader
          ,
          }:
          mergeAttrsList
            (map (loadPathName loader) pathNames);

        result =
          mapAttrs
            (_: load)
            cfg.loaders;
      in
      result;
  };
}
