{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.useCase.gaming;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      randovania

      (buildEnv {
        name = "${dolphin-emu.name}_and_${dolphin-emu-primehack.name}";
        ignoreCollisions = true;
        paths = [
          dolphin-emu
          dolphin-emu-primehack
        ];
      })
    ];
  };
}
