{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.mullvad;
in
{
  config = mkIf cfg.enable {
    # TODO: Maybe move these tools to my.programs.*
    home.packages = with pkgs; [
      mullvad-vpn
      mullvad-closest
    ];
  };
}
