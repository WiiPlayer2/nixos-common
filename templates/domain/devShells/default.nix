{
  perSystem =
    { config
    , pkgs
    , system
    , self'
    , inputs'
    , ...
    }:
    {
      devShells = {
        default = inputs'.common.devShells.default.override (prev: {
          packages = prev.packages ++ (with pkgs; [
            # Add your local devShell packages here
          ]);
        });
      };
    };
}
