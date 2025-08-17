{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule

    ../overlays
    ../pkgs
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    { inputs', self', lib, pkgs, ... }:
    {
      formatter = inputs'.nixpkgs-unstable.legacyPackages.nixfmt-tree;
      pre-commit.settings.hooks.nixpkgs-fmt.enable = true;

      apps.build-all.program =
        let
          allPackages =
            lib.map
            ({ value, ... }: value)
            (
              lib.attrsToList
              self'.packages
            );
          mkPkgsList =
            pkgs:
            lib.concatStringsSep
            "\n"
            (
              lib.map
              (x: x.pname or x.name)
              pkgs
            );
          brokenPackages =
            lib.filter
            (x: x.meta.broken or true)
            allPackages;
          brokenPackages' = mkPkgsList brokenPackages;
          unbrokenPackages =
            lib.filter
            (x: !(x.meta.broken or false))
            allPackages;
          unbrokenPackages' = mkPkgsList unbrokenPackages;
          closureInfo =
            pkgs.closureInfo {
              rootPaths = unbrokenPackages;
            };
          script = pkgs.writeShellApplication {
            name = "build-all";
            text = ''
              echo "Packages:"
              cat << EOF
              ${unbrokenPackages'}
              EOF

              echo ""
              echo "Broken packages:"
              cat << EOF
              ${brokenPackages'}
              EOF

              echo ""
              echo "Closure:"
              echo ${closureInfo}
            '';
          };
        in
          lib.getExe script;
    };
}
