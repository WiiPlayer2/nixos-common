{ lib
, pkgs
, config
, ...
}:
with lib;
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
  format = pkgs.formats.ini { };
  configFile = format.generate "supervisord.conf" cfg.settings;
in
{
  options.programs.supervisord = with lib; {
    enable = mkEnableOption "Whether supervisord is available.";
    enableSystemdShim = mkOption {
      type = types.bool;
      default = true;
    };
    settings = mkOption {
      type = format.type;
      default = { };
    };
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

  config = with lib; mkMerge [
    {
      programs.supervisord.settings = {
        inet_http_server = mkIf (cfg.config.inetHttpServer.enable) {
          port = cfg.config.inetHttpServer.port;
        };
        supervisord = cfg.config.supervisord;
        supervisorctl = { };
        "rpcinterface:supervisor"."supervisor.rpcinterface_factory" = "supervisor.rpcinterface:make_main_rpcinterface";
      } // (
        mapAttrs'
          (n: v: nameValuePair "program:${n}" {
            command = v.command;
            startsecs = mkIf (v.startsecs != null) v.startsecs;
            redirect_stderr = mkIf (v.redirect_stderr != null) v.redirect_stderr;
          })
          cfg.config.programs
      );
    }
    (mkIf cfg.enable {
      environment.packages = with pkgs; [
        supervisor
        (writeShellScriptBin "start-supervisord" ''
          ${
            if cfg.settings.supervisord.directory != null then
              "echo \"Switching to ${cfg.settings.supervisord.directory}\"; cd \"${cfg.settings.supervisord.directory}\""
            else
              ""
          }
          supervisord --nodaemon
        '')
      ];

      environment.etc."supervisord.conf".source = configFile;

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
    })
    (mkIf cfg.enableSystemdShim {
      programs.supervisord.settings =
        let
          # Use https://noogle.dev/f/lib/textClosureList for priority based on dependencies etc.
          mkServiceShim =
            { name, value }:
            {
              name = "program:systemd-${name}";
              value = {
                command = value.Service.ExecStart;
                startsecs = mkIf (value.Service.Type == "oneshot") 0;
              };
            };

          serviceShims =
            map
              mkServiceShim
              (attrsToList config.home-manager.config.systemd.user.services);

          settings =
            listToAttrs
              (
                serviceShims
              );
        in
        settings;
    })
  ];
}
