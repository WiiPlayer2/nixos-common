{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.programs.supervisord;
  mkDefaultEnableOption =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
    };
  dataDir = "${config.user.home}/supervisord";
in
{
  options.programs.supervisord = with lib; {
    enable = mkEnableOption "Whether supervisord is available.";
    config = {
      inetHttpServer = {
        enable = mkOption {
          description = "Whether a http server over network tcp socket is available.";
          type = types.bool;
          default = true;
        };
        port = mkOption {
          description = "The host:port on which the http server should listen";
          type = types.str;
          default = "127.0.0.1:9001";
        };
      };
      supervisord = {
        logfile = mkOption {
          description = "The logfile location";
          type = with types; nullOr str;
          default = "${dataDir}/supervisord.log";
        };
        pidfile = mkOption {
          description = "The pidfile location";
          type = with types; nullOr str;
          default = "${dataDir}/supervisord.pid";
        };
        directory = mkOption {
          description = "The directory to switch to in daemon mode";
          type = with types; nullOr str;
          default = dataDir;
        };
      };
      programs = mkOption {
        description = "The configured programs";
        type =
          with types;
          attrsOf (submodule {
            options = {
              enable = mkOption {
                description = "Whether this configured program is available.";
                type = types.bool;
                default = true;
              };
              command = mkOption {
                description = "The command to be start the program";
                type = types.str;
              };
              startsecs = mkOption {
                description = "The number of seconds a program must run before it's considered RUNNING";
                type = with types; nullOr int;
                default = null;
              };
              redirect_stderr = mkOption {
                description = "Whether the stderr stream should be redirected to the stdout stream.";
                type = with types; nullOr bool;
                default = null;
              };
            };
          });
      };
      rpcinterfaces = mkOption {
        description = "The configured rpc interfaces";
        type =
          with types;
          attrsOf (submodule {
            options = {
              enable = mkDefaultEnableOption "Whether this configured rpc interface is available.";
              rpcinterface_factory = mkOption {
                description = "The rpcinterface_factory method to use.";
                type = types.str;
              };
            };
          });
        default = {
          supervisor = {
            rpcinterface_factory = "supervisor.rpcinterface:make_main_rpcinterface";
          };
        };
      };
    };
  };

  config =
    with lib;
    mkIf cfg.enable {
      environment.packages = with pkgs; [
        supervisor
        (writeShellScriptBin "start-supervisord" ''
          ${
            if cfg.config.supervisord.directory != null then
              "echo \"Switching to ${cfg.config.supervisord.directory}\"; cd \"${cfg.config.supervisord.directory}\""
            else
              ""
          }
          supervisord --nodaemon
        '')
      ];

      environment.etc."supervisord.conf" = {
        text =
          let
            writeNullable = name: value: if value == null then "" else "${name}=${toString value}";
            buildSections =
              mapSection: sections:
              concatStringsSep "\n" (
                map (x: mapSection x.name x.value) (filter (x: x.value.enable) (attrsToList sections))
              );
            inetHttpServerSection =
              if cfg.config.inetHttpServer.enable then
                ''
                  [inet_http_server]
                  port=${cfg.config.inetHttpServer.port}
                ''
              else
                "";
            supervisordSection =
              let
                section = cfg.config.supervisord;
              in
              ''
                [supervisord]
                ${writeNullable "logfile" section.logfile}
                ${writeNullable "pidfile" section.pidfile}
                ${writeNullable "directory" section.directory}
              '';
            supervisorctlSection = ''
              [supervisorctl]
            '';
            programSection = name: program: ''
              [program:${name}]
              command=${program.command}
              ${writeNullable "startsecs" program.startsecs}
              ${writeNullable "redirect_stderr" program.redirect_stderr}
            '';
            programSections = concatStringsSep "\n" (
              map (x: programSection x.name x.value) (
                filter (x: x.value.enable) (attrsToList cfg.config.programs)
              )
            );
            rpcinterfaceSection = name: rpcinterface: ''
              [rpcinterface:${name}]
              supervisor.rpcinterface_factory=${rpcinterface.rpcinterface_factory}
            '';
            rpcinterfaceSections = buildSections rpcinterfaceSection cfg.config.rpcinterfaces;
          in
          ''
            ${inetHttpServerSection}
            ${supervisordSection}
            ${supervisorctlSection}
            ${programSections}
            ${rpcinterfaceSections}
          '';
      };

      build.activation.supervisord = ''
        $VERBOSE_ECHO "Ensuring data directory ${dataDir} exists"
        $DRY_RUN_CMD mkdir --parents "${dataDir}"

        if ${pkgs.supervisor}/bin/supervisorctl version; then
          $VERBOSE_ECHO "Reloading supervisord configuration and updating program states..."
          $DRY_RUN_CMD ${pkgs.supervisor}/bin/supervisorctl update all || true
        else
          $VERBOSE_ECHO "Starting supervisord..."
          $DRY_RUN_CMD ${pkgs.supervisor}/bin/supervisord
        fi
      '';
    };
}
