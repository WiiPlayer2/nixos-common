{ inputs, ... }:
{
  programs.zsh.initContent = ''
    source ${inputs.nixpkgs}/nixos/modules/programs/zsh/zinputrc
  '';
}
