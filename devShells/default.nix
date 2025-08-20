{
  perSystem =
    { config
    , pkgs
    , system
    , inputs'
    , ...
    }:
    {
      devShells.default =
        pkgs.mkShell {
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
