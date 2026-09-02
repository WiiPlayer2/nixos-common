{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      shell = {
        disabled = false;
        bash_indicator = builtins.fromJSON ''"\uebca" '';
        pwsh_indicator = builtins.fromJSON ''"\uebc7" '';
        zsh_indicator = builtins.fromJSON ''"\uf0e7" '';
        unknown_indicator = "?";
      };

      shlvl = {
        disabled = false;
      };

      status = {
        disabled = false;
      };

      kubernetes = {
        disabled = false;
        detect_files = [
          "helmfile.yaml"
        ];
        detect_extensions = [
          "helmfile.yaml"
        ];
      };

      # disabled due to not working apparently with fingerprint
      sudo = {
        disabled = true;
      };

      direnv.disabled = false;

      time.disabled = false;

      git_commit.only_detached = false;

      env_var = {
        NIXPKGS_ALLOW_UNFREE.format = "with [NIXPKGS_ALLOW_UNFREE]($style) ";
      };
    };
  };
}
