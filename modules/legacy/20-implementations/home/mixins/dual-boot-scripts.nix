{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.os.dualBoot;
in
{
  config = mkIf cfg.enable (
    let
      renderEntryList =
        name: entries: extraEntries:
        concatStringsSep "," (
          [ entries."${name}" ]
          ++ (map (x: x.value) (filter (x: x.name != name) (attrsToList entries)))
          ++ extraEntries
        );
      setBootOrderScriptName = name: "set-bootorder-${name}";
      setBootOrderScript =
        name: entries: extraEntries:
        "sudo ${pkgs.efibootmgr}/bin/efibootmgr --bootorder ${renderEntryList name entries extraEntries}";
      rebootToScriptName = name: "reboot-to-${name}";
      rebootToScript = name: entries: extraEntries: ''
        ${setBootOrderScriptName name} && sudo reboot
      '';
    in
    {
      home.packages =
        with pkgs;
        (
          (map (
            x:
            writeShellScriptBin (setBootOrderScriptName x.name) (
              setBootOrderScript x.name cfg.uefi.named cfg.uefi.extra
            )
          ) (attrsToList cfg.uefi.named))
          ++ (map (
            x:
            writeShellScriptBin (rebootToScriptName x.name) (
              rebootToScript x.name cfg.uefi.named cfg.uefi.extra
            )
          ) (filter (x: x.name != cfg.uefi.current) (attrsToList cfg.uefi.named)))
        );
    }
  );
}
