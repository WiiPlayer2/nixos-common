{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.steam;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      steam-run
      steam
    ];

    my.startup.steam.command = "steam -silent";
  };
}
