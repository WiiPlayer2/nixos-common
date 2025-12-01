# https://discourse.nixos.org/t/a-modern-and-secure-desktop-setup/41154
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.features.luks.tpm2;
in
{
  config = mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
    environment.systemPackages = with pkgs; [
      tpm2-tss
    ];
  };
}
