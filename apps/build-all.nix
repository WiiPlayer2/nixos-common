{
  perSystem =
    { pkgs, self', lib, ... }:
    {
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
