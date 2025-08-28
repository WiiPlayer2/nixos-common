{
  perSystem =
    { lib
    , config
    , pkgs
    , system
    , inputs'
    , ...
    }:
      with lib;
      {
        devShells.default =
          makeOverridable
            pkgs.mkShell
            {
              name = "nix-configs";
              packages = with pkgs; [
              ];
              shellHook = ''
                ${config.pre-commit.installationScript}
                export FLAKE_ROOT="$(pwd)"
              '';
            };
      };
}
