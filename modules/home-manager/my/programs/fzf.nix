{
  programs.fzf = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--walker=file,hidden"
    ];
  };
}
