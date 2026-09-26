{ inputs, ... }:
{
  imports = [
    inputs.self.homeModules.mutable-files
  ];

  programs.zsh.initContent = ''
    source ${inputs.nixpkgs}/nixos/modules/programs/zsh/zinputrc
  '';
}
