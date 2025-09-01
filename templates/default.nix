{ self, ... }:
{
  flake.templates = {
    default = self.templates.domain;
    domain = {
      path = ./domain;
      welcomeText = ''
        Run the following command to complete setup:

        ```
        nix run .#__repo__init-domain
        ```

        You might also want to add automatic pipelines for updating the common input using `apps.*.__ci__update`.
      '';
    };
  };
}
