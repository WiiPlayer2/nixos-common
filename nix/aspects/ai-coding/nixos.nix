{ inputs, ... }:
{ lib, pkgs, ... }:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };
  llama-server = lib.getExe' llama-cpp "llama-server";

  ttl = 900; # 15min
  contextSizes = [
    4
    8
    16
    32
    48
    56
    64
    72
    80
    88
    96
    104
    112
    120
  ];
  mkLlamaModel =
    {
      filePath,
      noCuda ? false,
      noVulkan ? false,
      contextSize ? 0,
      aliases ? [ ],
    }:
    {
      inherit ttl aliases;
      env = [
        "HOME=/tmp"
      ]
      ++ optional noCuda "CUDA_VISIBLE_DEVICES="
      ++ optional noVulkan "GGML_VK_VISIBLE_DEVICES=";
      cmd = ''
        ${llama-server} \
          --port ''${PORT} \
          -m ${escapeShellArg filePath} \
          --no-warmup \
          --parallel 1 \
          --ctx-size ${toString contextSize} \
          --gpu-layers 99 \
          --jinja
      '';
    };
  applyVariants =
    variants: attrs:
    concatMapAttrs (
      name: value:
      mapAttrs' (variantName: variantValue: {
        name = if variantName != "_" then "${name}-${variantName}" else name;
        value = value // variantValue;
      }) variants
    ) attrs;
  backendVariants = {
    _ = { };
    vulkan = {
      noCuda = true;
    };
    cpu = {
      noCuda = true;
      noVulkan = true;
    };
  };
  contextVariants =
    (genAttrs' contextSizes (ctx: {
      name = "ctx_${toString ctx}k";
      value = {
        contextSize = ctx * 1024;
      };
    }))
    // {
      ctx_max = { };
    };
  mkLLamaModels =
    {
      name,
      filePath,
    }:
    let
      baseVariant = {
        "${name}" = {
          inherit filePath;
        };
      };
      variants = pipe baseVariant [
        (applyVariants contextVariants)
        (applyVariants backendVariants)
      ];
      models = mapAttrs (_: mkLlamaModel) variants;
    in
    models;

  mkModelDownload =
    {
      repo,
      fileName,
    }:
    let
      url = "https://huggingface.co/${repo}/resolve/main/${fileName}?download=true";
      targetPath = "/var/lib/llama-cpp/models/${fileName}";
    in
    ''
      if [[ ! -f ${escapeShellArg targetPath} ]]; then
        ${getExe pkgs.wget} -O ${escapeShellArg targetPath} ${escapeShellArg url}
      fi
    '';
  modelDownloads = [
    {
      repo = "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF";
      fileName = "Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
    }
    {
      repo = "mistralai/Ministral-3-3B-Instruct-2512-GGUF";
      fileName = "Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
    }
    {
      repo = "mistralai/Ministral-3-3B-Reasoning-2512-GGUF";
      fileName = "Ministral-3-3B-Reasoning-2512-Q4_K_M.gguf";
    }
    {
      repo = "unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF";
      fileName = "Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
    }
  ];
  modelDownloadScript = pkgs.writeShellApplication {
    name = "download-llm-models";
    text = ''
      ${join "\n" (map mkModelDownload modelDownloads)}
    '';
  };
in
{
  imports = [
    inputs.self.nixosModules.service-llama-swap
  ];

  environment.systemPackages = [
    modelDownloadScript
    llama-cpp
  ];

  services = {
    llama-swap = {
      enable = true;
      port = 8090;
      settings = {
        # healthCheckTimeout = 3600; # 1h

        sendLoadingState = true;

        # models =
        #   (mkLLamaModels {
        #     name = "qwen3-coder-30b-a3b-instruct";
        #     filePath = "/var/lib/llama-cpp/models/Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
        #   })
        #   // (mkLLamaModels {
        #     name = "devstral-small-2-24b-instruct";
        #     filePath = "/var/lib/llama-cpp/models/Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
        #   })
        #   // (mkLLamaModels {
        #     name = "ministral3-3b-reasoning";
        #     filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Reasoning-2512-Q4_K_M.gguf";
        #   })
        #   // (mkLLamaModels {
        #     name = "ministral3-3b-instruct";
        #     filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
        #   });
      };

      llama-server-package = llama-cpp;
      llama-server-models = {
        ministral3-3b = {
          filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
        };
        ministral3-3b-reasoning = {
          filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
        };
        devstral-small-2-24b = {
          filePath = "/var/lib/llama-cpp/models/Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
        };
        qwen3-coder-30b = {
          filePath = "/var/lib/llama-cpp/models/Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
        };
      };
    };

    # open-webui = {
    #   enable = true;
    #   port = 8091;
    #   environment.WEBUI_AUTH = "False";
    # };

    # librechat = {
    #   enable = true;
    #   settings = {
    #     endpoints = {
    #       custom = [
    #         {
    #           name = "llama-swap (local)";
    #           baseURL = "http://localhost:8090/v1";
    #           models = {
    #             fetch = true;
    #           };
    #         }
    #       ];
    #     };
    #   };
    # };
  };
}
