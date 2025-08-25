{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.monado;
in
{
  config = mkIf cfg.enable {
    xdg.configFile."openxr/1/active_runtime.json".source =
      "${pkgs.monado}/share/openxr/1/openxr_monado.json";

    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite"
        ],
        "version" : 1
      }
    '';

    home.packages = with pkgs; [
      (writeShellScriptBin "add-steamvr-monado-driver" ''
        cd ~
        steam-run ~/.steam/steam/steamapps/common/SteamVR/bin/vrpathreg.sh adddriver ${pkgs.monado}/share/steamvr-monado
      '')
      (writeShellScriptBin "enable-wmr-direct-mode" ''
        xrandr --output $1 --set non-desktop 1
      '')
    ];
  };
}
