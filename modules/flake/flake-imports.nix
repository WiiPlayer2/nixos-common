inputs: {
  imports = [
    inputs.agenix-rekey.flakeModule
    inputs.git-hooks-nix.flakeModule
    inputs.agenix-shell.flakeModules.default
  ];
}
