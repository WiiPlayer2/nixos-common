{ self, ... }:
{
  flake.templates = {
    default = self.templates.domain;
    domain = {
      path = ./domain;
      welcomeText = ''
        Run the following commands to complete setup:

        ```
        git init
        git add .
        git commit -m "Add domain nixos files"
        direnv allow
        ```

        You might also want to add automatic pipelines for updating the common input using `apps.*.__ci__update` and add the common repository as a submodule under `flakes/common`.
      '';
    };
  };
}
