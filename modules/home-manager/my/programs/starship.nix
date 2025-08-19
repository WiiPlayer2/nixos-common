{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[✗](bold red)";
      };

      shell = {
        disabled = false;
        bash_indicator = builtins.fromJSON ''"\uebca" '';
        pwsh_indicator = builtins.fromJSON ''"\uebc7" '';
        zsh_indicator = builtins.fromJSON ''"\uf0e7" '';
        unknown_indicator = "?";
        style = "bright-cyan italic";
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
    };
  };
}
