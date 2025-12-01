{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.keepassxc;
in
{
  options.programs.keepassxc = {
    startupUnlockDelay = mkOption {
      description = "The delay after startup before unlocking";
      type = types.ints.unsigned;
      default = 3;
    };
    stores = mkOption {
      description = "The KeePass stores to use";
      type =
        with types;
        attrsOf (submodule {
          options = {
            file = mkOption {
              description = "The store file to open";
              type = path;
            };
            keyFile = mkOption {
              description = "The key file to the store if one is needed";
              type = nullOr path;
              default = null;
            };
          };
        });
      default = { };
    };
  };

  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        libsecret
        # keepassxc
        (writeShellScriptBin "keepassxc-unlock" (
          let
            unlockStore =
              name:
              { file, keyFile }:
              ''
                tmp_passwd=$(secret-tool lookup keepass ${name})
                database="${file}"
                keyfile="${toString keyFile}"
                dbus-send --print-reply --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.openDatabase \
                "string:$database" "string:$tmp_passwd" ${if keyFile != null then "\"string:$keyfile\"" else ""}
              '';
            unlockStores =
              stores:
              concatMapStrings (attr: unlockStore attr ({ keyFile = null; } // stores.${attr})) (
                attrNames stores
              );
          in
          ''
            #!/usr/bin/env bash
            # Get password using secret-tool and unlock keepassxc
            ${unlockStores cfg.stores}
          ''
        ))
        (writeShellScriptBin "keepassxc-lock" ''
          #!/usr/bin/env bash
          dbus-send --print-reply --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.lockAllDatabases
        '')
        (writeShellScriptBin "keepassxc-startup" ''
          #!/usr/bin/env bash
          keepassxc &
          sleep ${toString cfg.startupUnlockDelay}
          keepassxc-unlock
        '')
        (writeShellScriptBin "keepassxc-watch" ''
          #!/usr/bin/env bash
          # KeepassXC watch for logout and unlock a database

          dbus-monitor --session "type=signal,interface=org.xfce.ScreenSaver" | 
            while read MSG; do
              LOCK_STAT=`echo $MSG | grep boolean | awk '{print $2}'`
              if [[ "$LOCK_STAT" == "false" ]]; then
                  keepassxc-unlock
              fi
            done
        '')
      ];
    };
}
