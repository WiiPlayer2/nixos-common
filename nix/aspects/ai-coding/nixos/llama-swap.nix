{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
    mkIf
    escapeShellArgs
    mkPackageOption
    mkOption
    mkOptionDefault
    mkDefault
    types
    evalModules
    filterAttrs
    mapAttrsToList
    ;

  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  llamaModule =
    { config, ... }:
    {
      options = {
        package = mkPackageOption pkgs "llama-cpp" { };
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
          # ctx-size
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

  mkLlamaCmd =
    module:
    let
      config = evalModules {
        modules = [
          llamaModule
          module
        ];
      };
    in
    config.config.command;

  mkLlamaSwapModel =
    {
      name,
      model,
      context,
      llamaModule ? { },
    }:
    {
      inherit name;
      cmd = mkLlamaCmd {
        imports = [ llamaModule ];

        args = {
          hf-repo = mkDefault model;
          ctx-size = mkDefault context;
        };
      };
      capabilities = {
        inherit context;
        "in" = [
          "text"
          "image"
        ];
        out = [ "text" ];
        tools = true;
      };
    };

  qwen3_5_llama = {
    args = {
      temperature = 0.6;
      top-p = 0.95;
      top-k = 20;
      min-p = 0.0;
      presence-penalty = 0.0;
      repeat-penalty = 1.0;
      image-min-tokens = 1024;
    };
  };

  mkQwen3_5_08b =
    {
      quant,
      nameSuffix ? "",
      llamaModule ? { },
    }:
    mkLlamaSwapModel {
      name = "Qwen3.5 0.8B${nameSuffix}";
      model = "unsloth/Qwen3.5-0.8B-GGUF:${quant}";
      context = 262144;
      llamaModule = {
        imports = [
          qwen3_5_llama
          llamaModule
        ];
      };
    };

  mkQwen3_5_9b =
    {
      quant,
      nameSuffix ? "",
      llamaModule ? { },
    }:
    mkLlamaSwapModel {
      name = "Qwen3.5 9B MTP${nameSuffix}";
      model = "unsloth/Qwen3.5-9B-MTP-GGUF:${quant}";
      context = 262144;
      llamaModule = {
        imports = [
          qwen3_5_llama
          llamaModule
        ];
      };
    };

  mkQwen3_6_35b_a3b =
    {
      quant,
      nameSuffix ? "",
      llamaModule ? { },
    }:
    mkLlamaSwapModel {
      name = "Qwen3.6 35B A3B${nameSuffix}";
      model = "unsloth/Qwen3.6-35B-A3B-GGUF:${quant}";
      context = 262144;
      llamaModule = {
        imports = [
          qwen3_5_llama
          llamaModule
        ];
      };
    };

  qwen3_8_llama = {
    args = {
      temperature = 1.0;
      top-p = 0.95;
      top-k = 20;
      min-p = 0.0;
      presence-penalty = 1.0;
      repeat-penalty = 1.0;
      image-min-tokens = 1024;
      chat-template-kwargs = builtins.toJSON {
        reasoning_effort = "low";
      };
      reasoning-preserve = { };
    };
  };

  mkQwen3_8_27b =
    {
      quant,
      nameSuffix ? "",
      llamaModule ? { },
    }:
    mkLlamaSwapModel {
      name = "Qwen3.8 27B${nameSuffix}";
      model = "unsloth/Qwen3.8-27B-GGUF:${quant}";
      context = 262144;
      llamaModule = {
        imports = [
          qwen3_8_llama
          llamaModule
        ];
      };
    };

  mkQwen3_8_flash =
    {
      quant,
      nameSuffix ? "",
      llamaModule ? { },
    }:
    mkLlamaSwapModel {
      name = "Qwen3.8 Flash${nameSuffix}";
      model = "unsloth/Qwen3.8-Flash-Next-GGUF:${quant}";
      context = 262144;
      llamaModule = {
        imports = [
          qwen3_8_llama
          llamaModule
        ];
      };
    };
in
{
  environment.systemPackages = [
    llama-cpp
  ]
  ++ (with pkgs; [
    python3Packages.huggingface-hub
  ]);

  services = {
    llama-swap = {
      enable = true;
      port = 8090;
      settings = {
        healthCheckTimeout = 5 * 60; # 5min
        globalTTL = 60 * 60; # 15min
        sendLoadingState = false;
        includeAliasesInList = true;
        models = {
          "qwen3.5-0.8b" = mkQwen3_5_08b { quant = "UD-Q4_K_XL"; };
          "qwen3.5-9b" = mkQwen3_5_9b {
            quant = "UD-Q4_K_XL";
            llamaModule.args = {
              spec-type = "draft-mtp";
              spec-draft-n-max = 6;
            };
          };
          "qwen3.6-35b-a3b_q2" = mkQwen3_6_35b_a3b {
            quant = "UD-Q2_K_XL";
            nameSuffix = " (Q2)";
          };
          "qwen3.6-35b-a3b_q2_fit-2gb" = mkQwen3_6_35b_a3b {
            quant = "UD-Q2_K_XL";
            nameSuffix = " (Q2, fit 2GiB)";
            llamaModule.args.fit-target = 2 * 1024; # MiB
          };
          "qwen3.8-27b_q2" = mkQwen3_8_27b {
            quant = "UD-IQ2_S";
            nameSuffix = " (Q2)";
          };
          "qwen3.8-27b_q2_fit-2gb" = mkQwen3_8_27b {
            quant = "UD-IQ2_S";
            nameSuffix = " (Q2, fit 2GiB)";
            llamaModule.args.fit-target = 2 * 1024; # MiB
          };
          "swift-1.5-qwen3.8-27b_q2" = mkQwen3_8_27b {
            quant = "IQ2_S-mtp";
            nameSuffix = " (Swift 1.5, Q2)";
            llamaModule.args.hf-repo = "ukisai/Swift-1.5-Qwen3.8-27B-GSQ-RCO-GGUF:IQ2_S-mtp";
          };
          "swift-1.5-qwen3.8-27b_q2_fit-2gb" = mkQwen3_8_27b {
            quant = "IQ2_S-mtp";
            nameSuffix = " (Swift 1.5, Q2, fit 2GiB)";
            llamaModule.args = {
              hf-repo = "ukisai/Swift-1.5-Qwen3.8-27B-GSQ-RCO-GGUF:IQ2_S-mtp";
              fit-target = 2 * 1024; # MiB
            };
          };
          "qwen3.8-flash_q2" = mkQwen3_8_flash {
            quant = "UD-Q2_K_XL";
            nameSuffix = " (Q2)";
          };
        };
      };

      # llama-server = {
      #   package = llama-cpp;
      #   defaults = {
      #     dynamicPort = false;
      #     additionalArgs = [
      #       "--fit"
      #       "on"
      #       "--fit-target"
      #       "512"
      #       "--port"
      #       "\${PORT}"
      #     ];
      #   };
      #   models = modelConfigs;
      # };
    };
  };

  systemd.services.llama-swap = {
    restartIfChanged = false;
    stopIfChanged = false;
  };

  security.sudo.extraRules = [
    {
      groups = [ "gamemode" ];
      commands = [
        {
          command = "${getExe' pkgs.systemd "systemctl"} start llama-swap";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${getExe' pkgs.systemd "systemctl"} stop llama-swap";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${getExe' pkgs.systemd "systemctl"} restart llama-swap";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.gamemode = mkIf (config.programs.gamemode ? startCommands) {
    startCommands = "/run/wrappers/bin/sudo ${getExe' pkgs.systemd "systemctl"} stop llama-swap";
    endCommands = "/run/wrappers/bin/sudo ${getExe' pkgs.systemd "systemctl"} start llama-swap";
  };
}
