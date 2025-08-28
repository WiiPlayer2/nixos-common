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
      '';
    };
  };
}
