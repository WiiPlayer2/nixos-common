{
  perSystem =
    {
      config,
      pkgs,
      system,
      self',
      inputs',
      ...
    }:
    {
      devShells = {
        default = inputs'.common.devShells.default.override (prev: {
          packages =
            prev.packages
            ++ (with pkgs; [
              # Add your local devShell packages here
            ]);

          # Override shell hook to setup pre-commit using local configuration
          shellHook = ''
            ${config.pre-commit.installationScript}
            export FLAKE_ROOT="$(pwd)"
          '';
        });
      };
    };
}
