{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.features.yubikey;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pam_u2f

      # TODO: maybe check if any key is already added as apparently the first entry must contain the username
      (writeShellScriptBin "add-yubikey-auth" ''
        mkdir -p ~/.config/Yubico
        pamu2fcfg -n >> ~/.config/Yubico/u2f_keys
      '')
    ];
  };
}
