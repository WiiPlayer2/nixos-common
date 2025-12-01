{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.wireshark;
in
{
  # TODO: maybe configure also on NixOS: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/wireshark.nix
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wireshark
    ];
  };
}
