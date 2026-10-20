_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg' = config.services.llama-swap;
  cfg = cfg'.llama-server;

  modelModule =
    { config, ... }:
    {
      options = {
        name = mkOption {
          type = types.nullOr types.str;
          default = null;
        };

        contextSize = mkOption {
          type = types.nullOr types.int;
          default = null;
        };

        package = (mkPackageOption pkgs "llama-cpp" { }) // {
          default = cfg.package;
        };

        args = mkOption {
          type = with types; attrsOf (nullOr anything); # Should probably be more precise
        };

        command = mkOption {
          type = types.str;
          internal = true;
          readOnly = true;
        };
      };

      config = {
        args = {
          no-warmup = mkOptionDefault { };
          parallel = mkOptionDefault 1;
          # gpu-layers = mkOptionDefault "auto"; # default
          jinja = mkOptionDefault { };
          cache-type-k = mkOptionDefault "q4_0";
          cache-type-v = mkOptionDefault "q4_0";
          # hf-repo
          ctx-size = mkOptionDefault config.contextSize;
          port = mkOptionDefault "\${PORT}";
          threads = mkOptionDefault (-1);
        };
        command =
          let
            mapArg =
              name: value:
              let
                optionName = "--${name}";
              in
              if value == { } then
                [ optionName ]
              else if builtins.isList value then
                [
                  optionName
                  (builtins.concatStringsSep "," (map toString value))
                ]
              else
                [
                  optionName
                  (toString value)
                ];
            mappedArgs = builtins.concatLists (
              mapAttrsToList mapArg (filterAttrs (_: v: v != null) config.args)
            );
            command = "${getExe' config.package "llama-server"} ${escapeShellArgs mappedArgs}";
          in
          command;
      };
    };
in
{
  options.services.llama-swap = {
    user = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    llama-server = {
      package = mkPackageOption pkgs "llama-cpp" { };
      models = mkOption {
        type = types.attrsOf (types.submodule modelModule);
        default = { };
      };
    };
  };

  config = mkIf cfg'.enable {
    services.llama-swap.settings.models =
      let
        mapModel =
          name: modelCfg:
          (optionalAttrs (modelCfg.name != null) { inherit (modelCfg) name; })
          // {
            cmd = modelCfg.command;
            capabilities =
              (optionalAttrs (modelCfg.contextSize != null) { context = modelCfg.contextSize; })
              // {
                "in" = [ "text" ];
                out = [ "text" ];
                tools = true;
              };
          };
        models = mapAttrs mapModel cfg.models;
      in
      models;

    systemd.services.llama-swap = mkIf (cfg'.user != null) {
      serviceConfig = {
        User = cfg'.user;
        DynamicUser = mkForce false;
        ProtectHome = mkForce false;

        MemoryDenyWriteExecute = mkForce false; # for .NET (due to JIT)
      };
    };
  };
}
