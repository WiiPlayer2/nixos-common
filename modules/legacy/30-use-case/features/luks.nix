{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.luks;
in
{
  options.my.features.luks = {
    tpm2 = {
      enable = mkEnableOption "LUKS TPM2 unlock";
    };
  };

  config = mkMerge [
    (mkIf (cfg.tpm2.enable) { })
  ];
}
