{ lib, config, ... }:
with lib;
let
  cfg = config.programs.rclone;
  replaceSlashes = builtins.replaceStrings [ "/" " " ] [ "-" "-" ];
in
{
  options.programs.rclone = {
    remotes = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          bisync = mkOption {
            type = types.attrsOf (types.submodule (
              { config, ... }:
              {
                options = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };
                  localPath = mkOption {
                    type = types.path;
                  };
                  flags = mkOption {
                    type = types.listOf types.str;
                    default = [];
                    apply = escapeShellArgs;
                  };
                };
              }
            ));
            default = {};
          };
        };
      });
    };
  };

  config = {
    systemd.user =
      let
        mkBisyncName =
          { remoteName, remotePath, ... }:
          "rclone-bisync:${replaceSlashes remotePath}@${remoteName}";
        mkBisyncTimer =
          { remoteName, remotePath, bisyncConfig } @ args:
          nameValuePair (mkBisyncName args) {
            Unit.Description = "Regular rclone bisync for ${remoteName}:${remotePath}";
            Timer = {
              OnStartupSec = "10s";
              OnUnitActiveSec = "5min";
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
          };
        mkBisyncService =
          { remoteName, remotePath, bisyncConfig } @ args:
          nameValuePair (mkBisyncName args) {
            Unit.Description = "Regular rclone bisync for ${remoteName}:${remotePath}";
            Service = {
              ExecStart = concatStringsSep " " [
                (getExe cfg.package)
                "bisync"
                (escapeShellArg "${remoteName}:${remotePath}")
                (escapeShellArg bisyncConfig.localPath)
                "--dry-run"
                bisyncConfig.flags
              ];
            };
          };
        mkBisyncUnits =
          { remoteName, remotePath, bisyncConfig } @ args:
          let
            timer = mkBisyncTimer args;
            service = mkBisyncService args;
          in
          {
            timers.${timer.name} = timer.value;
            services.${service.name} = service.value;
          };
        units =
          foldl
          recursiveUpdate
          {}
          (
            flatten
            (
              map
              (
                { name, value }:
                let
                  remoteName = name;
                in
                map
                (
                  { name, value }:
                  let
                    remotePath = name;
                  in
                    mkBisyncUnits {
                      inherit remoteName remotePath;
                      bisyncConfig = value;
                    }
                )
                (attrsToList (filterAttrs (n: v: v.enable) value.bisync))
              )
              (attrsToList cfg.remotes)
            )
          );
      in
        units;
  };
}
