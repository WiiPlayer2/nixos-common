{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        powershell
      ];

      home.file.powershell-profile = {
        target = ".config/powershell/Microsoft.PowerShell_profile.ps1";
        text = ''
          Invoke-Expression (&starship init powershell)
        '';
      };
    };
}
