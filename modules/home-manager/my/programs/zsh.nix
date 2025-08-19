{ flake-inputs, ... }:
{
  programs.zsh = {
    enable = true;
    initContent = ''
      source ${flake-inputs.nixpkgs}/nixos/modules/programs/zsh/zinputrc
    '';
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    syntaxHighlighting.enable = true;
  };
}
